page 50124 "Get PR Lines"
{
    Caption = 'Get PR Lines';
    PageType = List;

    Editable = false;
    UsageCategory = Lists;

    ApplicationArea = All;
    SourceTable = "PR Resources";




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
                field("Line No."; "Line No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; "Item No.")
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
                // field(Quantity; Quantity) { }
                field("Direct Unit Cost Excl. VAT "; "Direct Unit Cost Excl. VAT ") { ApplicationArea = All; }
                field("Line Discount %"; "Line Discount %") { ApplicationArea = All; }
                field("Total Amount"; "Total Amount") { ApplicationArea = All; }
                //field("Quantity to Receive"; "Quantity to Receive") { }
                //field("Quantity Received"; "Quantity Received") { }
                //field("Expected Receipt Date"; "Expected Receipt Date") { }



            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction in [Action::OK, Action::LookupOK] then
            createLines();
    end;

    procedure createLines()
    var

        PRResourcesTable: Record "PR Resources";
        PRTable: Record "Purchase Requisition";
        POSubForm: Record "PO SubForm";
        code_unit: Codeunit "PO Codeunit";
        PRAllResources: Record "PR Resources";
    begin
        CurrPage.SetSelectionFilter(Rec);
        if Rec.FindSet() then begin
            repeat
                POSubForm.SetRange("PR No.", rec.ID);
                if POSubForm.FindSet() then begin
                    POSubForm.SetRange("No.", Rec."Item No.");
                    if POSubForm.FindSet() then begin
                        POSubForm.SetRange(ID, code_unit.GetPurchaseOrderNo());
                        if POSubForm.FindSet() then
                            Message('Item already Added.');
                    end;

                end;


                // Message(Format(code_unit.GetPurchaseOrderNo()));
                POSubForm.Init();
                POSubForm.ID := code_unit.GetPurchaseOrderNo();
                POSubForm."No." := Rec."Item No.";
                POSubForm.Description := Rec.Description;
                POSubForm."Register User Id" := Rec."Register User Id";
                POSubForm."Registered User Name" := Rec."Registered User Name";
                POSubForm."Line Discount %" := Rec."Line Discount %";
                POSubForm."PR No." := Rec.ID;
                POSubForm."Unit of Measure" := Rec."Unit of Measure";
                POSubForm."Date Needed" := Rec."Date Needed";
                POSubForm."Deptt. Code" := Rec."Deptt. Code";
                POSubForm.Quantity := Rec."Requested Qunatity";
                POSubForm."Direct Unit Cost Excl. VAT " := Rec."Direct Unit Cost Excl. VAT ";
                POSubForm."Total Amount" := Rec."Total Amount";
                POSubForm.Insert();
                Message('item added');

                Clear(POSubForm);
            until Rec.Next() = 0;

        end;
    end;


}