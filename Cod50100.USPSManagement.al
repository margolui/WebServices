codeunit 50100 "USPS Management"
{
    procedure ApplyAddress(CompareRec: Record "USPS Adress Verify")
    var
        Customer: Record Customer;
    begin
        case CompareRec.Type of
            CompareRec.Type::Customer:
                begin
                    Customer.Get(CompareRec."No.");
                    Customer.Validate(Name, CompareRec."USPS FirmName");
                    Customer.Validate(Address, CompareRec."USPS Address 1");
                    Customer.Validate("Address 2", CompareRec."USPS Address 2");
                    Customer.Validate(City, CompareRec."USPS City");
                    Customer.Validate("Post Code", CompareRec."USPS Zip5");
                    Customer.Validate(County, CompareRec."USPS State");
                    Customer.Modify(true);
                end;

        end;
    end;

    procedure VerifyCustomerAdress(var Customer: Record Customer)
    var
        Setup: Record "USPS Setup";
        CompareRec: Record "USPS Adress Verify";
        Parameters: XmlDocument;
        Result: XmlDocument;
        Address: XmlElement;
        AVR: XmlElement;
        ResultTxt: Text;
    begin
        if not Setup.Get() then
            Error('UPSP Setup is needed, please enter URL and UserID');

        if not CompareRec.Get(CompareRec.Type::Customer, Customer."No.") then begin
            CompareRec.Init();
            CompareRec.Type := CompareRec.Type::Customer;
            CompareRec."No." := Customer."No.";
            CompareRec.Insert(true);
        end;
        CompareRec.Name := Customer.Name;
        CompareRec."Address 1" := Customer.Address;
        CompareRec."Address 2" := Customer."Address 2";
        CompareRec.City := Customer.City;
        CompareRec.County := Customer.County;
        CompareRec."Post Code" := Customer."Post Code";

        PrepareXml(CompareRec, Setup);

        CompareRec.Modify();
        Commit();
        Page.Run(50101, CompareRec);
    end;

    local procedure PrepareXml(var CompareRec: Record "USPS Adress Verify"; var Setup: Record "USPS Setup")
    var
        Parameters: XmlDocument;
        Result: XmlDocument;
        Address: XmlElement;
        AVR: XmlElement;
        ResultTxt: Text;
        ErrorResultLbl: Label 'USPS returned an error: %1', Comment = '%1 is the error';
    begin
        Parameters := XmlDocument.Create();
        Address := XmlElement.Create('Adress');
        Address := XmlElement.Create('Adress');
        Address.Attributes().Set('ID', '0');
        Address.Add(AddField('FirmName', CompareRec.Name));
        Address.Add(AddField('Address1', CompareRec."Address 1"));
        Address.Add(AddField('Address2', CompareRec."Address 2"));
        Address.Add(AddField('City', CompareRec.City));
        Address.Add(AddField('State', CompareRec.County));
        Address.Add(AddField('Zip5', CompareRec."Post Code"));
        Address.Add(AddField('Zip4', ''));                          //TODO
        AVR := XmlElement.Create('AddressValidaeRequest');
        AVR.Attributes().Set('USERID', Setup.UserID);
        AVR.Add(Address);
        Parameters.Add(AVR);
        Result := CallWebService('Verify', Parameters);

        if GetField(Result, 'AddreddValidateResponse/Addredd[1]/Error/Description') <> '' then
            Error(ErrorResultLbl, GetField(Result, 'AddreddValidateResponse/Addredd[1]/Error/Description'));

        CompareRec."USPS FirmName" := GetField(Result, 'AddressvalidateResponse/Address[1]/FirmName');
        CompareRec."USPS Address 1" := GetField(Result, 'AddressvalidateResponse/Address[1]/Address1');
        CompareRec."USPS Address 2" := GetField(Result, 'AddressvalidateResponse/Address[1]/Address2');
        CompareRec."USPS Business" := GetField(Result, 'AddressvalidateResponse/Address[1]/USPSBusiness');
        CompareRec."USPS City" := GetField(Result, 'AddressvalidateResponse/Address[1]/USPSCity');
        CompareRec."USPS Address 2" := GetField(Result, 'AddressvalidateResponse/Address[1]/Address2');
        CompareRec."USPS State" := GetField(Result, 'AddressvalidateResponse/Address[1]/USPSState');
        CompareRec."USPS Zip5" := GetField(Result, 'AddressvalidateResponse/Address[1]/USPSZip5');
        CompareRec."USPS Zip4" := GetField(Result, 'AddressvalidateResponse/Address[1]/USPSZip4');
    end;

    local procedure GetField(var XML: XmlDocument; Path: Text): Text;
    var
        V: Variant;
        N: XmlNode;
    begin
        if XML.SelectSingleNode(Path, N) then
            exit(N.AsXmlElement().InnerText);
    end;

    local procedure AddField(Name: Text; Value: Text): XmlElement
    var
        e: XmlElement;
    begin
        e := XmlElement.Create(Name);
        e.Add(Value);
        exit(e);
    end;

    local procedure CallWebService(API: Text; XMLin: XmlDocument): XmlDocument
    var
        Setup: Record "USPS Setup";
        TypeHelper: Codeunit "Type Helper";
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        QueryString: Text;
        XMLtxt: Text;
        TxtOut: Text;
        XMLOut: XmlDocument;
    begin
        if not Setup.Get() then
            Error('UPSP Setup is needed, please enter URL and UserID');
        XMLin.WriteTo(XMLtxt);
        TypeHelper.UrlEncode(XMLtxt);
        QueryString := '?API=' + API + '&XML=' + XMLtxt;
        Request.Method := 'Get';
        Request.GetHeaders(Headers);
        Headers.Add('User-Agent', 'Dynamics 365 Business Central');
        Request.SetRequestUri(Setup.URL + QueryString);
        if Client.Send(Request, Response) then begin
            if Response.HttpStatusCode() = 200 then begin
                Response.Content().ReadAs(TxtOut);
                if XmlDocument.ReadFrom(TxtOut, XMLOut) then
                    exit(XMLOut)
                else
                    Error('Expected XML format from UPSP, got this instead: %1', TxtOut);

            end else
                Error('UPSP web service call failed (status code %1)', Response.HttpStatusCode());
        end else
            Error('Can`t contact UPSP, Connection error!');
    end;

}
