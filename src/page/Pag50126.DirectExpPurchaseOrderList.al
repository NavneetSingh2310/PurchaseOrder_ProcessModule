page 50126 "Direct Exp Purchase Order List"
{
    Caption = 'Direct Expense Purchase Order List ';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Purchase Order";
    CardPageId = "Purchase Order Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type") { ApplicationArea = all; }
                field("Buy-from Vendor No."; "Buy-from Vendor No.") { ApplicationArea = All; }
                field("Order Type"; "Order Type") { ApplicationArea = All; }
                field("No."; "No.") { ApplicationArea = All; }
                field("Order Date"; "Order Date") { ApplicationArea = All; }
                field("Posting Date"; "Posting Date") { ApplicationArea = All; }
                field("Due Date"; "Due Date") { ApplicationArea = All; }
                field("Location Code"; "Location Code") { ApplicationArea = All; }
                field("Department Code"; "Department Code") { ApplicationArea = All; }
                field("Currency Code"; "Currency Code") { ApplicationArea = All; }
                field(Status; Status) { ApplicationArea = All; }
                field("Department Type"; "Department Type") { ApplicationArea = All; }
                field("Assigned User Id"; "Assigned User Id") { ApplicationArea = All; }


            }
        }

    }

    trigger OnOpenPage()
    var
        code_unit: Codeunit "PO Codeunit";


    begin
        code_unit.SetOrderType(rec."Order Type"::"Direct Expense");
        SetFilter("Order Type", 'Direct Expense');
        //code_unit.ClearAllTablesData();
    end;



}