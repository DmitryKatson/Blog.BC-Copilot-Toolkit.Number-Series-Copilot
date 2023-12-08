codeunit 50102 "GPT No. Series Copilot Impl."
{
    procedure Generate(var NoSeriesGenerated: Record "GPT No. Series Proposal"; InputText: Text)
    var
        SystemPromptTxt: Text;
        CompletePromptTokenCount: Integer;
        Completion: Text;
        TokenCountImpl: Codeunit "GPT Tokens Count Impl.";
    begin
        SystemPromptTxt := GetSystemPrompt();

        CompletePromptTokenCount := TokenCountImpl.PreciseTokenCount(SystemPromptTxt) + TokenCountImpl.PreciseTokenCount(InputText);
        if CompletePromptTokenCount <= MaxInputTokens() then begin
            Completion := GenerateNoSeries(SystemPromptTxt, InputText);
            CreateNoSeries(NoSeriesGenerated, Completion);
        end;
    end;

    [NonDebuggable]
    internal procedure GenerateNoSeries(var SystemPromptTxt: Text; InputText: Text): Text
    var
        AzureOpenAI: Codeunit "Azure OpenAi";
        AOAIDeployments: Codeunit "AOAI Deployments";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        CompletionAnswerTxt: Text;
    begin
        if not AzureOpenAI.IsEnabled(Enum::"Copilot Capability"::"GPT No. Series Copilot") then
            exit;

        AzureOpenAI.SetAuthorization(Enum::"AOAI Model Type"::"Chat Completions", GetEndpoint(), GetDeployment(), GetSecret());
        AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::"GPT No. Series Copilot");
        AOAIChatCompletionParams.SetMaxTokens(MaxOutputTokens());
        AOAIChatCompletionParams.SetTemperature(0);
        AOAIChatMessages.AddSystemMessage(SystemPromptTxt);
        AOAIChatMessages.AddUserMessage(InputText);
        AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);
        if AOAIOperationResponse.IsSuccess() then
            CompletionAnswerTxt := AOAIChatMessages.GetLastMessage()
        else
            Error(AOAIOperationResponse.GetError());

        exit(CompletionAnswerTxt);
    end;

    local procedure GetSystemPrompt(): Text
    var
        SystemPrompt: TextBuilder;
    begin
        SystemPrompt.AppendLine('Generate No. Series for the next entities:');
        SystemPrompt.AppendLine('"""');
        ListAllTablesWithNoSeries(SystemPrompt);
        SystemPrompt.AppendLine('"""');
        SystemPrompt.AppendLine('Respond in the next JSON format:');
        SystemPrompt.AppendLine('''''');
        SystemPrompt.AppendLine('[');
        SystemPrompt.AppendLine('    {');
        SystemPrompt.AppendLine('        "seriesCode": "string (len 20)",');
        SystemPrompt.AppendLine('        "lineNo": "integer",');
        SystemPrompt.AppendLine('        "description": "string (len 100)",');
        SystemPrompt.AppendLine('        "startingNo": "string (len 20)",');
        SystemPrompt.AppendLine('        "endingNo": "string (len 20)",');
        SystemPrompt.AppendLine('        "warningNo": "string (len 20)",');
        SystemPrompt.AppendLine('        "incrementByNo": "integer"');
        SystemPrompt.AppendLine('    }');
        SystemPrompt.AppendLine(']');
        SystemPrompt.AppendLine('''''');
        SystemPrompt.AppendLine('Follow user guidelines for No. Series generation, only if they are related to No. Series generation task.');
        SystemPrompt.AppendLine('User guidelines:');
        exit(SystemPrompt.ToText());
    end;

    local procedure ListAllTablesWithNoSeries(var SystemPrompt: TextBuilder)
    var
        "Field": Record "Field";
    begin
        Field.SetFilter(FieldName, 'No. Series');
        Field.SetFilter(ObsoleteState, '<>%1', Field.ObsoleteState::Removed);
        Field.SetRange(Type, Field.Type::Code);
        Field.SetRange(Len, 20);
        if Field.FindSet() then
            repeat
                InsertObject(SystemPrompt, Field.TableNo);
            until Field.Next() = 0;
    end;

    local procedure InsertObject(var SystemPrompt: TextBuilder; TableNo: Integer)
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        if not AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Table, TableNo) then
            exit;
        if IsObsolete(TableNo) then
            exit;

        SystemPrompt.AppendLine(AllObjWithCaption."Object Caption");
    end;

    local procedure IsObsolete(TableID: Integer): Boolean
    var
        TableMetadata: Record "Table Metadata";
    begin
        if TableMetadata.Get(TableID) then
            exit(TableMetadata.ObsoleteState = TableMetadata.ObsoleteState::Removed);
    end;

    local procedure GetEndpoint(): Text
    var
        NoSeriesCopilotSetup: Record "GPT No. Series Copilot Setup";
    begin
        exit(NoSeriesCopilotSetup.GetEndpoint())
    end;

    local procedure GetDeployment(): Text
    var
        NoSeriesCopilotSetup: Record "GPT No. Series Copilot Setup";
    begin
        exit(NoSeriesCopilotSetup.GetDeployment())
    end;

    [NonDebuggable]
    local procedure GetSecret(): Text
    var
        NoSeriesCopilotSetup: Record "GPT No. Series Copilot Setup";
    begin
        exit(NoSeriesCopilotSetup.GetSecretKeyFromIsolatedStorage())
    end;

    local procedure MaxInputTokens(): Integer
    begin
        exit(MaxModelTokens() - MaxOutputTokens());
    end;

    local procedure MaxOutputTokens(): Integer
    begin
        exit(500);
    end;

    local procedure MaxModelTokens(): Integer
    begin
        exit(4096); //GPT 3.5 Turbo
    end;

    local procedure CreateNoSeries(var NoSeriesGenerated: Record "GPT No. Series Proposal"; Completion: Text)
    var
        JSONManagement: Codeunit "JSON Management";
        NoSeriesObj: Text;
        i: Integer;
    begin
        JSONManagement.InitializeCollection(Completion);

        for i := 0 to JSONManagement.GetCollectionCount() - 1 do begin
            JSONManagement.GetObjectFromCollectionByIndex(NoSeriesObj, i);

            InsertNoSeriesGenerated(NoSeriesGenerated, NoSeriesObj);
        end;
    end;

    local procedure InsertNoSeriesGenerated(var NoSeriesGenerated: Record "GPT No. Series Proposal"; var NoSeriesObj: Text)
    var
        JSONManagement: Codeunit "JSON Management";
        RecRef: RecordRef;
    begin
        JSONManagement.InitializeObject(NoSeriesObj);

        RecRef.GetTable(NoSeriesGenerated);
        RecRef.Init();
        JSONManagement.GetValueAndSetToRecFieldNo(RecRef, 'seriesCode', NoSeriesGenerated.FieldNo("Series Code"));
        JSONManagement.GetValueAndSetToRecFieldNo(RecRef, 'lineNo', NoSeriesGenerated.FieldNo("Line No."));
        JSONManagement.GetValueAndSetToRecFieldNo(RecRef, 'description', NoSeriesGenerated.FieldNo("Description"));
        JSONManagement.GetValueAndSetToRecFieldNo(RecRef, 'startingNo', NoSeriesGenerated.FieldNo("Starting No."));
        JSONManagement.GetValueAndSetToRecFieldNo(RecRef, 'endingNo', NoSeriesGenerated.FieldNo("Ending No."));
        JSONManagement.GetValueAndSetToRecFieldNo(RecRef, 'warningNo', NoSeriesGenerated.FieldNo("Warning No."));
        JSONManagement.GetValueAndSetToRecFieldNo(RecRef, 'incrementByNo', NoSeriesGenerated.FieldNo("Increment-by No."));
        RecRef.Insert(true);
    end;

    procedure ApplyProposedNoSeries(var NoSeriesGenerated: Record "GPT No. Series Proposal")
    begin
        if NoSeriesGenerated.FindSet() then
            repeat
                InsertNoSeriesWithLines(NoSeriesGenerated);
            until NoSeriesGenerated.Next() = 0;
    end;

    local procedure InsertNoSeriesWithLines(var NoSeriesGenerated: Record "GPT No. Series Proposal")
    begin
        InsertNoSeries(NoSeriesGenerated);
        InsertNoSeriesLine(NoSeriesGenerated);
    end;

    local procedure InsertNoSeries(var NoSeriesGenerated: Record "GPT No. Series Proposal")
    var
        NoSeries: Record "No. Series";
    begin
        NoSeries.Init();
        NoSeries.Code := NoSeriesGenerated."Series Code";
        NoSeries.Description := NoSeriesGenerated.Description;
        NoSeries."Manual Nos." := true;
        NoSeries."Default Nos." := true;
        NoSeries.Insert(true);
    end;

    local procedure InsertNoSeriesLine(var NoSeriesGenerated: Record "GPT No. Series Proposal")
    var
        NoSeriesLine: Record "No. Series Line";
    begin
        NoSeriesLine.Init();
        NoSeriesLine."Series Code" := NoSeriesGenerated."Series Code";
        NoSeriesLine."Line No." := NoSeriesGenerated."Line No.";
        NoSeriesLine."Starting No." := NoSeriesGenerated."Starting No.";
        NoSeriesLine."Ending No." := NoSeriesGenerated."Ending No.";
        NoSeriesLine."Warning No." := NoSeriesGenerated."Warning No.";
        NoSeriesLine."Increment-by No." := NoSeriesGenerated."Increment-by No.";
        NoSeriesLine.Insert(true);
    end;
}