codeunit 50101 "GPT Tokens Count Impl."
{
    trigger OnRun()
    var
        Text: Text;
        Tokens: List of [Text];
        TokensList: Text;
        i: Integer;
    begin
        Text := 'Helllllo AL developers! Welcome to the AI world!!!';
        Message('%1\\Approximate token count: %2\Precise token count: %3', Text, ApproximateTokenCount(Text), PreciseTokenCount(Text));

        Tokens := ListTokens(Text);
        for i := 1 to Tokens.Count do begin
            TokensList += Tokens.Get(i) + ', ';
        end;

        Message('%1\\Tokens:\%2', Text, TokensList);
    end;

    procedure ApproximateTokenCount(Input: Text): Decimal
    var
        AzureOpenAI: Codeunit "Azure OpenAI";
    begin
        exit(AzureOpenAI.ApproximateTokenCount(Input));
    end;

    procedure PreciseTokenCount(Input: Text): Integer
    var
        RestClient: Codeunit "Rest Client";
        Content: Codeunit "Http Content";
        JContent: JsonObject;
        JTokenCount: JsonToken;
        Uri: Label 'https://azure-openai-tokenizer.azurewebsites.net/api/tokensCount', Locked = true;
    begin
        JContent.Add('text', Input);
        Content.Create(JContent);
        RestClient.Send("Http Method"::GET, Uri, Content).GetContent().AsJson().AsObject().Get('tokensCount', JTokenCount);
        exit(JTokenCount.AsValue().AsInteger());
    end;

    procedure ListTokens(Input: Text) TokenList: List of [Text]
    var
        RestClient: Codeunit "Rest Client";
        Content: Codeunit "Http Content";
        JContent: JsonObject;
        JTokenArray: JsonToken;
        JToken: JsonToken;
        Uri: Label 'https://azure-openai-tokenizer.azurewebsites.net/api/tokens', Locked = true;
        i: Integer;
    begin
        JContent.Add('text', Input);
        Content.Create(JContent);
        RestClient.Send("Http Method"::GET, Uri, Content).GetContent().AsJson().AsObject().Get('tokens', JTokenArray);

        for i := 0 to JTokenArray.AsArray().Count - 1 do begin
            JTokenArray.AsArray().Get(i, JToken);
            TokenList.Add(JToken.AsValue().AsText());
        end;
    end;
}
