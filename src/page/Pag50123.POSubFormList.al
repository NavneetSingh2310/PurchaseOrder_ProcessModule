page 50123 "POSubForm List"
{
    Caption = 'POSubForm List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "PO SubForm";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(ID; ID)
                {
                    ApplicationArea = All;

                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }

                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = All;
                }
                field("PR No."; "PR No.")
                {
                    ApplicationArea = All;

                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Description2; Description2)
                {
                    ApplicationArea = All;
                }
                field("Requested Qunatity"; "Requested Qunatity")
                {
                    ApplicationArea = All;
                }
                field("Register User Id"; "Register User Id")
                {
                    ApplicationArea = All;
                }
                field("Registered User Name"; "Registered User Name")
                {
                    ApplicationArea = All;
                }
                field("Deptt. Code"; "Deptt. Code")
                {
                    ApplicationArea = All;
                }
                field("Sub.Account Code"; "Sub.Account Code")
                {
                    ApplicationArea = All;
                }
                field("Date Needed"; "Date Needed")
                {
                    ApplicationArea = All;
                }
                field(Purpose; Purpose)
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; "Total Amount") { ApplicationArea = All; }
                field("Direct Unit Cost Excl. VAT "; "Direct Unit Cost Excl. VAT ") { ApplicationArea = All; }
                field(Quantity; Quantity) { ApplicationArea = All; }
                field("Line Discount %"; "Line Discount %") { ApplicationArea = All; }



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