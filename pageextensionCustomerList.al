// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

pageextension 50100 CustomerListExt extends "Customer List"
{
    actions
    {
        addafter(Workflow)
        {
            action(Verify)
            {
                Caption = 'Verify Adress';
                Image = Addresses;
                ApplicationArea = All;
                trigger OnAction()
                var
                    Mgt: Codeunit "USPS Management";
                begin
                    Mgt.VerifyCustomerAdress(Rec);
                end;
            }
        }
    }
}