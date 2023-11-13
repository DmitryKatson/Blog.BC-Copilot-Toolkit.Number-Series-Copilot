codeunit 50100 "GPT Upsell Copilot Install"
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
        LearnMoreUrlTxt: Label 'https://katson.com/blogs', Locked = true;
    begin
        if EnvironmentInformation.IsSaaS() then
            if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"GPT Upsell Copilot") then
                CopilotCapability.RegisterCapability(Enum::"Copilot Capability"::"GPT Upsell Copilot", LearnMoreUrlTxt);
    end;
}