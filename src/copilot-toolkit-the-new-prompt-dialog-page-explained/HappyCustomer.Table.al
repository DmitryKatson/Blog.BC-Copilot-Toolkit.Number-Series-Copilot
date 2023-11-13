table 50102 "GPT Happy Customer"
{
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Customer No."; Code[20])
        {

        }
        field(3; "Happiness Level"; enum "GPT Customer Happiness Level")
        {

        }
        field(4; "Generated Text"; text[250])
        {

        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}