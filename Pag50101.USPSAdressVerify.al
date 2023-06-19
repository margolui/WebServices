page 50101 "USPS Adress Verify"
{
    ApplicationArea = All;
    Caption = 'USPS Adress Verify';
    PageType = Card;
    SourceTable = "USPS Adress Verify";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            group("Business Central")
            {
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Address 1"; Rec."Address 1")
                {
                    ToolTip = 'Specifies the value of the Address 1 field.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ToolTip = 'Specifies the value of the Address 2 field.';
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.';
                }
                field(County; Rec.County)
                {
                    ToolTip = 'Specifies the value of the County field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the value of the Post Code field.';
                }
            }
            group(USPS)
            {
                field("USPS Address 1"; Rec."USPS Address 1")
                {
                    ToolTip = 'Specifies the value of the USPS Address 1 field.';
                }
                field("USPS Address 2"; Rec."USPS Address 2")
                {
                    ToolTip = 'Specifies the value of the USPS Address 2 field.';
                }
                field("USPS Business"; Rec."USPS Business")
                {
                    ToolTip = 'Specifies the value of the USPS Business field.';
                }
                field("USPS City"; Rec."USPS City")
                {
                    ToolTip = 'Specifies the value of the USPS City field.';
                }
                field("USPS FirmName"; Rec."USPS FirmName")
                {
                    ToolTip = 'Specifies the value of the USPS FirmName field.';
                }
                field("USPS State"; Rec."USPS State")
                {
                    ToolTip = 'Specifies the value of the USPS State field.';
                }
                field("USPS Zip4"; Rec."USPS Zip4")
                {
                    ToolTip = 'Specifies the value of the USPS Zip4 field.';
                }
                field("USPS Zip5"; Rec."USPS Zip5")
                {
                    ToolTip = 'Specifies the value of the USPS Zip5 field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Apply)
            {
                Caption = 'Apply';
                Image = Apply;
                ToolTip = 'Apply the fields from USPS to the Business Central entity';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Mgt: Codeunit "USPS Management";
                begin
                    if Confirm('Update %1 %2 with USPS address&', true, Rec.Type, Rec.Name) then begin
                        Mgt.ApplyAddress(Rec);
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }
}
