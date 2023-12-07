// page 50102 "GPT Upsell Copilot Setup"
// {

//     Caption = 'Upsell with Copilot Setup';
//     PageType = Card;
//     SourceTable = "GPT Upsell Copilot Setup";
//     InsertAllowed = false;
//     DeleteAllowed = false;
//     ApplicationArea = All;
//     UsageCategory = Administration;


//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 field(Endpoint; Rec.Endpoint)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Deployment; Rec.Deployment)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(SecretKey; Rec.Secret)
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }

//     trigger OnOpenPage()
//     begin
//         if not Rec.Get() then
//             Rec.Insert();
//     end;
// }