page 50100 "GPT Upsell Proposal"
{
    Caption = 'Upsell with Copilot';
    DataCaptionExpression = InputText;
    PageType = PromptDialog;
    IsPreview = true;
    Extensible = false;
    // PromptMode = Content;
    ApplicationArea = All;
    Editable = true;
    SourceTable = "GPT Upsell Proposal";
    SourceTableTemporary = true;
    InherentPermissions = X;
    InherentEntitlements = X;

    layout
    {
        area(PromptOptions)
        {

        }
        area(Prompt)
        {
            field(InputText; InputText)
            {
                Caption = 'Request';
                MultiLine = true;
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }

        }
        area(Content)
        {
            field(GeneratedText; GeneratedText)
            {
                Caption = 'Suggestions';
                MultiLine = true;
                ApplicationArea = All;
            }
            // part(ProposalDetails; "GPT Upsell Proposal Sub")
            // {
            //     Caption = 'Upsell proposals';
            //     ShowFilter = false;
            //     ApplicationArea = All;
            //     Editable = true;
            //     Enabled = true;
            // }
        }
    }
    actions
    {
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Tooltip = 'Generate a upsell suggestions based on the input items';
                trigger OnAction()
                begin
                    GeneratedText := 'You asked me about: ' + InputText;
                    // GenerateUpsellSuggestions();
                end;
            }
            // systemaction(Attach)
            // {
            //     Caption = 'Setup';
            //     trigger OnAction()
            //     begin
            //         Page.Run(Page::"GPT Upsell Copilot Setup");
            //     end;
            // }
            systemaction(Cancel)
            {
                ToolTip = 'Discards all suggestions and dismisses the dialog';
            }
            systemaction(Ok)
            {
                Caption = 'Keep it';
                ToolTip = 'Accepts the current suggestion and dismisses the dialog';
            }
        }
    }

    var
        InputText: Text;
        GeneratedText: Text;

    // trigger OnQueryClosePage(CloseAction: Action): Boolean
    // var
    // begin
    //     if CloseAction = CloseAction::OK then
    //         ApplyProposedUpsellItems();
    // end;

    // local procedure GenerateUpsellSuggestions()
    // var
    //     UpsellCopilotImpl: Codeunit "GPT Upsell Copilot Impl.";
    //     TempUpsellProposalGenerated: Record "GPT Upsell Proposal" temporary;
    // begin
    //     UpsellCopilotImpl.GenerateJobQueueEntries(TempUpsellProposalGenerated, InputText);
    //     CurrPage.ProposalDetails.Page.Load(TempUpsellProposalGenerated);
    // end;

    // local procedure ApplyProposedUpsellItems()
    // var
    //     UpsellCopilotImpl: Codeunit "GPT Upsell Copilot Impl.";
    //     TempUpsellProposalGenerated: Record "GPT Upsell Proposal" temporary;
    // begin
    //     CurrPage.ProposalDetails.Page.GetTempRecord(TempUpsellProposalGenerated);
    //     UpsellCopilotImpl.ApplyProposedUpsellItems(TempUpsellProposalGenerated);
    // end;
}