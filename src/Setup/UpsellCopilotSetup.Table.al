// table 50101 "GPT Upsell Copilot Setup"
// {
//     Description = 'Upsell with Copilot Setup';

//     fields
//     {
//         field(1; "Code"; Code[20])
//         {
//             DataClassification = CustomerContent;
//             Caption = 'Code';

//         }

//         field(2; Endpoint; Text[250])
//         {
//             DataClassification = CustomerContent;
//             Caption = 'Endpoint';
//         }

//         field(3; Deployment; Text[250])
//         {
//             Caption = 'Deployment';
//         }

//         field(4; Secret; Text[250])
//         {
//             DataClassification = CustomerContent;
//             Caption = 'Secret';
//             ExtendedDatatype = Masked;
//         }
//     }

//     keys
//     {
//         key(PK; Code)
//         {
//             Clustered = true;
//         }
//     }

//     procedure GetEndpoint() Endpoint: Text[250]
//     var
//         Rec: Record "GPT Upsell Copilot Setup";
//     begin
//         Rec.Get();
//         exit(Rec.Endpoint);
//     end;

//     procedure GetDeployment() Deployment: Text[250]
//     var
//         Rec: Record "GPT Upsell Copilot Setup";
//     begin
//         Rec.Get();
//         exit(Rec.Deployment);
//     end;

//     [NonDebuggable]
//     procedure GetSecret() Secret: Text
//     var
//         Rec: Record "GPT Upsell Copilot Setup";
//     begin
//         Rec.Get();
//         exit(Rec.Secret);
//     end;
// }