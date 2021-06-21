page 50122 "PO SubForm ListPart"
{
    Caption = 'PO SubForm ListPart';
    PageType = ListPart;
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
                    Visible = false;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                    // trigger OnValidate()
                    // var
                    //     code_unit: Codeunit "PO Codeunit";
                    // begin
                    //     ID := code_unit.GetPurchaseOrderNo()

                    // end;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = all;
                    Visible = false;

                }

                field("No."; "No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        Item: Record Item;
                    // code_unit: Codeunit "PR Codeunit";
                    begin
                        Item.Get("No.");
                        Description := Item.Description;
                        "Register User Id" := UserId;
                        "Registered User Name" := UserId;
                        //"Deptt. Code" := code_unit.GetDepartment();
                    end;
                }
                field("PR No."; "PR No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    // Visible = false;
                    // trigger OnValidate()
                    // var
                    //     LineRecord: Record "PR Resources";
                    //     POSubFormRecord: Record "PO SubForm";
                    //     code_unit: Codeunit "PO Codeunit";
                    // begin

                    //     LineRecord.SetRange(ID, "PR No.");
                    //     if LineRecord.FindSet() then
                    //         repeat
                    //             POSubFormRecord.ID := code_unit.GetPurchaseOrderNo();
                    //             //POSubFormRecord."Line No." := LineRecord."Line No.";

                    //             POSubFormRecord."PR No." := "PR No.";
                    //             POSubFormRecord."No." := LineRecord."Item No.";
                    //             POSubFormRecord.Description := LineRecord.Description;
                    //             POSubFormRecord."Register User Id" := LineRecord."Register User Id";
                    //             POSubFormRecord."Registered User Name" := LineRecord."Registered User Name";
                    //             POSubFormRecord."Requested Qunatity" := LineRecord."Requested Qunatity";
                    //             Message('%1 %2 %3', POSubFormRecord.ID, POSubFormRecord."Line No.", POSubFormRecord."No.");
                    //             POSubFormRecord.Insert();
                    //         // Rec.ID := code_unit.GetPurchaseOrderNo();
                    //         // Rec."No." := LineRecord."Item No.";
                    //         // Rec.Description := LineRecord.Description;



                    //         until LineRecord.Next() = 0

                    //end;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; "Location Code") { ApplicationArea = all; }
                field(Description2; Description2)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        "Total Amount" := Quantity * "Direct Unit Cost Excl. VAT ";
                    end;
                }

                field("Quantity to Receive"; "Quantity to Receive")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        if Rec.Quantity < "Quantity to Receive" then
                            Error('Quantity to Receive should be equal of less than Quantity');
                    end;
                }
                field("Quantity Received"; "Quantity Received")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Direct Unit Cost Excl. VAT "; "Direct Unit Cost Excl. VAT ")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        "Total Amount" := Quantity * "Direct Unit Cost Excl. VAT ";
                    end;
                }
                field("Line Discount %"; "Line Discount %") { ApplicationArea = All; }
                field("Total Amount"; "Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Expected Receipt Date"; "Expected Receipt Date") { ApplicationArea = All; }

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


            }
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