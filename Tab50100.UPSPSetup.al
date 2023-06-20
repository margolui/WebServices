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
    }
    keys
    {
        key(PK; Ukey)
        {
            Clustered = true;
        }
    }
}
