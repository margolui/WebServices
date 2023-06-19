table 50100 "USPS Setup"
{
    Caption = 'USPS Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Ukey; Code[10])
        {
            Caption = 'Ukey';
            DataClassification = ToBeClassified;
        }
        field(2; URL; Text[100])
        {
            Caption = 'URL';
            DataClassification = ToBeClassified;
        }
        field(3; UserID; Text[30])
        {
            Caption = 'UserID';
            DataClassification = ToBeClassified;
        }
        field(4; ip; Text[30])
        {
            Caption = 'ip';
            DataClassification = ToBeClassified;
        }
        field(5; network; Text[30])
        {
            Caption = 'network';
            DataClassification = ToBeClassified;
        }
        field(6; versions; Text[30])
        {
            Caption = 'version';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; Ukey)
        {
            Clustered = true;
        }
    }
}
