page 50129 "My journal"
{
    Caption = 'My journal';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Gen. Journal Line";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.") { ApplicationArea = All; }
                field("Line No."; "Line No.") { ApplicationArea = All; }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                    ApplicationArea = All;

                }
                field("Journal Template Name"; "Journal Template Name") { ApplicationArea = All; }
                field(Amount; Amount) { ApplicationArea = All; }

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