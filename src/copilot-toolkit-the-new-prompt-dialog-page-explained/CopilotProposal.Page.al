page 50103 "GPT Copilot Proposal"
{
    Caption = 'Generate with Copilot';
    DataCaptionExpression = InputText;
    PageType = PromptDialog;
    IsPreview = true;
    Extensible = false;
    ApplicationArea = All;
    SourceTable = "GPT Happy Customer";
    SourceTableTemporary = true;

    layout
    {
        // area(PromptOptions)
        // {
        //     field(HappinessLevel; HappinessLevel)
        //     {
        //         ApplicationArea = All;
        //         Caption = 'How happy should the customer be?';
        //         trigger OnValidate()
        //         begin

        //         end;
        //     }
        // }
        area(Prompt)
        {
            field(InputText; InputText)
            {
                ShowCaption = false;
                MultiLine = true;
                ApplicationArea = All;
                trigger OnValidate()
                begin

                end;
            }
        }
        area(Content)
        {
            field(GeneratedText; Rec."Generated Text")
            {
                ShowCaption = false;
                MultiLine = true;
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        area(SystemActions)
        {
            systemaction(Generate)
            {
                trigger OnAction()
                var
                // ProgressDialog: Dialog;
                begin
                    // ProgressDialog.Open('Making Customer Happy...');
                    Rec."Generated Text" := GenerateText();
                    SaveToHistory();
                    // ProgressDialog.Close();
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
            systemaction(Regenerate)
            {
                trigger OnAction()
                begin
                    Rec."Generated Text" := GenerateText();
                    SaveToHistory();
                end;
            }
            systemaction(Attach)
            {
                Caption = 'Setup';
                trigger OnAction()
                begin
                    Page.Run(Page::"GPT Upsell Copilot Setup");
                end;
            }
        }
    }

    var
        InputText: Text;
        HappinessLevel: Enum "GPT Customer Happiness Level";

    trigger OnAfterGetCurrRecord()
    begin
        HappinessLevel := Rec."Happiness Level";
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = CloseAction::Ok then begin
            // Here you can do something with the generated text and save result to a database
            Message('You accepted the generated text: ' + Rec."Generated Text");
        end;
    end;

    procedure SetCustomer(Customer: Record Customer)
    begin
        InputText := 'Make ' + Customer.Name + ' happy';
        Rec."Customer No." := Customer."No.";
    end;

    local procedure GenerateText(): Text
    begin
        exit('You asked me to ' + InputText + ' and I did it with the level of happiness ' + Format(HappinessLevel));
    end;

    local procedure SaveToHistory()
    begin
        Rec."Entry No." := Rec.Count + 1;
        Rec."Happiness Level" := HappinessLevel;
        Rec.Insert();
    end;
}