// Temporary AL table to keep the history of No. Series proposals in the copilot
table 50103 "GPT No. Series Proposal"
{
    TableType = Temporary;

    fields
    {
        field(1; "Series Code"; Code[20])
        {
            Caption = 'Series Code';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }

        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Starting No."; Code[20])
        {
            Caption = 'Starting No.';
        }
        field(5; "Ending No."; Code[20])
        {
            Caption = 'Ending No.';
        }
        field(6; "Warning No."; Code[20])
        {
            Caption = 'Warning No.';
        }
        field(7; "Increment-by No."; Integer)
        {
            Caption = 'Increment-by No.';
        }
    }

    keys
    {
        key(PK; "Series Code", "Line No.")
        {
            Clustered = true;
        }
    }
}