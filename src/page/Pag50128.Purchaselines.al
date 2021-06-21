page 50128 "Purchaselines"
{
    Caption = 'Purchase Lines';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Purch. Rcpt. Line";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.") { ApplicationArea = All; }
                field("No."; "No.") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Buy-from Vendor No."; "Buy-from Vendor No.") { ApplicationArea = All; }


            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}