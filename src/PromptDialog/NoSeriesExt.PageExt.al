pageextension 50100 "GPT No. Series Ext" extends "No. Series"
{
    actions
    {
        addfirst(Promoted)
        {
            actionref("GPT Generate_Promoted"; "GPT Generate") { }
        }
        addlast("&Series")
        {
            action("GPT Generate")
            {
                Caption = 'Generate';
                ToolTip = 'Generate No. Series using Copilot';
                Image = Sparkle;
                ApplicationArea = All;
                trigger OnAction()
                var
                    NoSeriesCopilot: Page "GPT No. Series Proposal";
                begin
                    NoSeriesCopilot.LookupMode := true;
                    if NoSeriesCopilot.RunModal = Action::LookupOK then
                        CurrPage.Update();
                end;
            }
        }
    }
}