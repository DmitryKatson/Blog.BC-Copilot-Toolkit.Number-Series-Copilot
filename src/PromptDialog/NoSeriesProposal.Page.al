page 50100 "GPT No. Series Proposal"
{
    Caption = 'Generate No. Series with Copilot';
    DataCaptionExpression = InputText;
    PageType = PromptDialog;
    IsPreview = true;
    Extensible = false;
    // PromptMode = Content;
    ApplicationArea = All;
    Editable = true;
    SourceTable = "GPT No. Series Proposal";
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
                ShowCaption = false;
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
            part(ProposalDetails; "GPT No. Series Proposal Sub")
            {
                Caption = 'No. Series proposals';
                ShowFilter = false;
                ApplicationArea = All;
                Editable = true;
                Enabled = true;
            }
        }
    }
    actions
    {
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Tooltip = 'Generate no. series';
                trigger OnAction()
                begin
                    GenerateNoSeries();
                end;
            }
            systemaction(Regenerate)
            {
                Caption = 'Regenerate';
                Tooltip = 'Regenerate no. series';
                trigger OnAction()
                begin
                    GenerateNoSeries();
                end;
            }
            systemaction(Attach)
            {
                Caption = 'Setup';
                trigger OnAction()
                begin
                    Page.Run(Page::"GPT No. Series Copilot Setup");
                end;
            }
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

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
    begin
        if CloseAction = CloseAction::OK then
            ApplyProposedNoSeries();
    end;

    local procedure GenerateNoSeries()
    var
        NoSeriesCopilotImpl: Codeunit "GPT No. Series Copilot Impl.";
        NoSeriesGenerated: Record "GPT No. Series Proposal";
    begin
        NoSeriesCopilotImpl.Generate(NoSeriesGenerated, InputText);
        CurrPage.ProposalDetails.Page.Load(NoSeriesGenerated);
    end;

    local procedure ApplyProposedNoSeries()
    var
        NoSeriesCopilotImpl: Codeunit "GPT No. Series Copilot Impl.";
        NoSeriesGenerated: Record "GPT No. Series Proposal";
    begin
        CurrPage.ProposalDetails.Page.GetTempRecord(NoSeriesGenerated);
        NoSeriesCopilotImpl.ApplyProposedNoSeries(NoSeriesGenerated);
    end;
}