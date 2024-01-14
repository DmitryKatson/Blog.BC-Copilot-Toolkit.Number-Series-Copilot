codeunit 50100 "GPT No. Series Copilot Install"
{
    Subtype = Install;

    trigger OnInstallAppPerDatabase()
    begin
        RegisterCapability();
    end;

    local procedure RegisterCapability()
    var
        CopilotCapability: Codeunit "Copilot Capability";
        EnvironmentInformation: Codeunit "Environment Information";
        LearnMoreUrlTxt: Label 'https://katson.com/blog', Locked = true;
    begin
        if EnvironmentInformation.IsSaaS() then
            if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"GPT No. Series Copilot") then
                CopilotCapability.RegisterCapability(Enum::"Copilot Capability"::"GPT No. Series Copilot", LearnMoreUrlTxt);
    end;
}