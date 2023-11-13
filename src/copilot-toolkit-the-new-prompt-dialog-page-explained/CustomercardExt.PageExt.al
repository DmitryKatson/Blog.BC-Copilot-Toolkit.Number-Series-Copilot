pageextension 50100 "GPT Customer card Ext" extends "Customer Card"
{
    actions
    {
        addfirst("&Customer")
        {
            action("GPT Happy Customer")
            {
                Caption = 'Make Customer Happy!';
                ToolTip = 'Make Customer Happy with Copilot';
                ApplicationArea = All;
                Image = SparkleFilled;
                trigger OnAction()
                var
                    CopilotProposal: Page "GPT Copilot Proposal";
                begin
                    CopilotProposal.SetCustomer(Rec);
                    CopilotProposal.RunModal;
                end;
            }
        }

        addfirst(Promoted)
        {
            actionref("GPTHappyCustomer_Promoted"; "GPT Happy Customer") { }
        }
    }
}