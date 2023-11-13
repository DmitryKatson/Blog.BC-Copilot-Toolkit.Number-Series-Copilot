page 50101 "GPT Upsell Proposal Sub"
{

    Caption = 'Upsell Proposals';
    PageType = ListPart;
    SourceTable = "GPT Upsell Proposal";
    SourceTableTemporary = true;
    DeleteAllowed = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    InherentPermissions = X;
    InherentEntitlements = X;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Discount %"; Rec."Discount %")
                {
                    ApplicationArea = All;
                }
                field("AI Explanation"; Rec."AI Explanation")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
