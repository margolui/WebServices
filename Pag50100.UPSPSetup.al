page 50100 "USPS Setup"
{
    ApplicationArea = All;
    Caption = 'UPSP Setup';
    PageType = Card;
    SourceTable = "USPS Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(URL; Rec.URL)
                {
                    ToolTip = 'Specifies the value of the URL field.';
                }
                field(UserID; Rec.UserID)
                {
                    ToolTip = 'Specifies the value of the UserID field.';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if Rec.IsEmpty() then
            Rec.Insert(true);
    end;
}
