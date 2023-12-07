// // Temporary AL table to keep the history of Upsell items in the copilot
// table 50100 "GPT Upsell Proposal"
// {
//     TableType = Temporary;

//     fields
//     {
//         field(1; "Item No."; Code[20])
//         {
//             Caption = 'No.';
//         }
//         field(2; Description; Text[100])
//         {
//             Caption = 'Name';
//         }
//         field(3; Quantity; Decimal)
//         {
//             Caption = 'Qty.';
//         }
//         field(4; "Unit Price"; Decimal)
//         {
//             Caption = 'Unit Price';
//         }
//         field(5; "Discount %"; Decimal)
//         {
//             Caption = 'Disc. %';
//         }
//         field(6; "AI Explanation"; Text[2048])
//         {
//             Caption = 'AI Explanation';
//         }
//     }
// }