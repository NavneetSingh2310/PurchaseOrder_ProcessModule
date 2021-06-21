page 50121 "Purchase Order Card"
{
    Caption = 'Purchase Order';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Purchase Order";


    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = page_editable;

                field("No."; "No.")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    NotBlank = true;

                    trigger OnAssistEdit()
                    var
                        Series_Page: Page "No. Series List";
                        Series_Table: Record "No. Series";
                        NoSeriesMgt: Codeunit NoSeriesManagement;
                        CurrentSeries: Code[15];
                        Series: Record "No. Series";
                        code_unit: Codeunit "PO Codeunit";


                    begin
                        Series_Table.Reset();
                        Series_Table.SetFilter(Code, '*-PO');
                        Clear(Series_Page);
                        Series_Page.SetRecord(Series_Table);
                        Series_Page.SetTableView(Series_Table);
                        Series_Page.LookupMode(true);

                        IF Series_Page.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            Series_Page.GetRecord(Series_Table);
                            "No." := Series_Table.Code;
                            CurrentSeries := "No.";
                            Series.Get(CurrentSeries);
                            "No." := NoSeriesMgt.GetNextNo("No.", 0D, true);
                            "Document Type" := 'Order';
                            if Series_Table.Description = 'GA Purchase Order' then
                                "Department Type" := "Department Type"::"GA Dept"
                            else
                                if Series_Table.Description = 'PR Purchase Order' then
                                    "Department Type" := "Department Type"::"PR Dept"
                                else
                                    if Series_Table.Description = 'CS Purchase Order' then
                                        "Department Type" := "Department Type"::"CS Dept";

                            code_unit.SetPurchaseOrderNo("No.");


                            status := status::Open;
                            "Document Date" := Today;

                        end


                    end;
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        rec: Record Vendor;
                    begin

                        rec.get("Buy-from Vendor No.");
                        Vendor := rec.Name;

                    end;
                }
                field(Vendor; Vendor)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Location Code"; "Location Code") { ApplicationArea = All; }
                field("Order Type"; "Order Type") { ApplicationArea = All; Editable = false; }
                field("Department Type"; "Department Type") { ApplicationArea = All; Editable = false; }
                field("Require Advance Payment"; "Require Advance Payment") { ApplicationArea = All; }
                field("Advance Payment Amount"; "Advance Payment Amount") { ApplicationArea = All; }
                field("Reason Code"; "Reason Code") { ApplicationArea = All; }
                field("Document Date"; "Document Date") { ApplicationArea = All; }
                field("DR NO."; "DR NO.") { ApplicationArea = All; }
                field("ATP No."; "ATP No.") { ApplicationArea = All; }
                field("SI No."; "SI No.") { ApplicationArea = All; }
                field("Posting Date"; "Posting Date") { ApplicationArea = All; }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnValidate()
                    begin
                        if Status = Status::Released then begin
                            page_editable := true;
                            listPart_editable := true;
                            SendForApproval_enabled := false;
                            reopen_enabled := false;
                            getPRLines_enabled := false;
                        end;
                    end;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }


            }
            part("Purchase Order SubForm"; "PO SubForm ListPart")
            {
                ApplicationArea = All;
                SubPageLink = ID = field("No.");
                Editable = listPart_editable;

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                Promoted = true;
                Enabled = SendForApproval_enabled;

                trigger OnAction()
                var
                    code_unit: Codeunit "PO Codeunit";
                begin
                    if status = status::Open then begin
                        code_unit.SendPOForApproval(Rec."No.");
                        SendForApproval_enabled := false;
                        page_editable := false;
                        listPart_editable := false;

                    end
                    else
                        Message('Status must be Open');
                end;

            }
            action("Get PR Lines")
            {
                ApplicationArea = All;
                Image = GetLines;
                Promoted = true;
                Enabled = getPRLines_enabled;
                trigger OnAction()
                var
                    _page: Page "Get PR Lines";
                    PRResourcesTable: Record "PR Resources";
                    PRTable: Record "Purchase Requisition";
                    POSubForm: Record "PO SubForm";
                    code_unit: Codeunit "PO Codeunit";
                    PRAllResources: Record "PR Resources";

                begin


                    PRResourcesTable.SetRange(Processed, true);
                    PRResourcesTable.FindSet();

                    PRResourcesTable.SetRange("Deptt. Code", Format("Department Type"));
                    PRResourcesTable.FindSet();

                    _page.SetTableView(PRResourcesTable);
                    _page.LookupMode := true;
                    if _page.RunModal() = Action::LookupOK then begin



                    end;


                end;

            }
            action("Statistics")
            {
                ApplicationArea = All;
                Image = Statistics;
                Promoted = true;
                trigger OnAction()
                var
                    StatisticsRecord: Record Statistics;
                    Resources: Record "PO SubForm";
                    StatisticsPage: Page "Statistic Card";
                    "Amount Excl. VAT": Decimal;
                    "Inv. Discount Amount": Decimal;
                    "Total Incl. VAT": Decimal;
                    "VAT Amount": Decimal;
                    "Total Excl. VAT": Decimal;
                    "Purchase(LYC)": Decimal;
                    Quantity: Integer;
                    Parcels: Integer;
                    "Net Weight": Decimal;
                    "Gross Weight": Decimal;
                    Volume: Decimal;
                    "No of Tax Lines": Integer;

                begin
                    "Amount Excl. VAT" := 0;
                    "Inv. Discount Amount" := 0;
                    "Total Incl. VAT" := 0;
                    "VAT Amount" := 0;
                    "Total Excl. VAT" := 0;
                    "Purchase(LYC)" := 0;
                    Quantity := 0;
                    Parcels := 0;
                    "Net Weight" := 0;
                    "Gross Weight" := 0;
                    Volume := 0;
                    "No of Tax Lines" := 0;
                    Resources.SetRange(ID, "No.");
                    if Resources.FindSet() then
                        repeat
                            "Amount Excl. VAT" := "Amount Excl. VAT" + Resources."Amount Excl. VAT";
                            "Total Excl. VAT" := "Total Excl. VAT" + Resources."Total Amount";
                            "Total Incl. VAT" := "Total Incl. VAT" + Resources."Total Amount";
                            "VAT Amount" := "VAT Amount" + Resources."VAT Amount";
                            "Purchase(LYC)" := "Purchase(LYC)" + Resources."Purchase(LYC)";
                            Quantity := Quantity + Resources.Quantity;
                            Parcels := Parcels + Resources.Parcels;
                            "Net Weight" := "Net Weight" + Resources."Net Weight";
                            "Gross Weight" := "Gross Weight" + Resources."Gross Weight";
                            Volume := Volume + Resources.Volume;
                            "No of Tax Lines" := "No of Tax Lines" + 1;

                        until Resources.Next() = 0;
                    StatisticsRecord.DeleteAll();
                    StatisticsRecord.Init();
                    StatisticsRecord.PRno := Rec."No.";
                    StatisticsRecord."Amount Excl. VAT" := "Amount Excl. VAT";
                    StatisticsRecord."Total Excl. VAT" := "Total Excl. VAT";
                    StatisticsRecord."Total Incl. VAT" := "Total Incl. VAT";
                    StatisticsRecord."VAT Amount" := "VAT Amount";
                    StatisticsRecord."Purchase(LYC)" := "Purchase(LYC)";
                    StatisticsRecord.Quantity := Quantity;
                    StatisticsRecord.Parcels := Parcels;
                    StatisticsRecord."Net Weight" := "Net Weight";
                    StatisticsRecord."Gross Weight" := "Gross Weight";
                    StatisticsRecord.Volume := Volume;
                    StatisticsRecord."No of Tax Lines" := "No of Tax Lines";
                    StatisticsRecord.Insert();
                    StatisticsPage.SetTableView(StatisticsRecord);
                    StatisticsPage.Run();



                end;

            }
            action("Reopen")
            {
                ApplicationArea = All;
                Image = ReOpen;
                Promoted = true;

                Enabled = reopen_enabled;
                trigger OnAction()
                var
                    code_unit: Codeunit "PO Codeunit";
                begin
                    if status = status::"Pending Approval" then
                        code_unit.ReOpenPO(Rec."No.")
                    else
                        if status = status::Released then
                            Message('Can not be re-open as document is already released')
                        else
                            if status = status::Open then
                                Message('Document is already Open');


                end;
            }

            action("Post")
            {
                ApplicationArea = all;
                Image = Post;
                Promoted = true;
                Enabled = post_enabled;
                trigger OnAction()
                var
                    POSubFormResources: Record "PO SubForm";
                    Selection: Integer;
                    code_unit: Codeunit "PO Codeunit";
                begin


                    if Rec.Status <> Rec.Status::Released then
                        Error('Status must be Released');
                    if Rec."ATP No." = 0 then begin
                        Error('Enter APT No.');

                    end;
                    Selection := Dialog.StrMenu('Receive');

                    if Selection = 1 then begin

                        code_unit.GeneratePostedPurchaseReceipt(xRec);




                    end;


                end;
            }

            action("Make advance payment")
            {
                ApplicationArea = all;
                Image = Payment;
                trigger OnAction()
                var
                    code_unit: Codeunit "PO Codeunit";
                begin
                    if "Require Advance Payment" = true then begin
                        if "Advance Payment Amount" <> 0 then begin
                            code_unit.GeneratePaymentJournalEntry(xRec);
                        end;
                    end;
                end;
            }

            action("Report")
            {
                Image = Report;
                Promoted = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    report1: Report "Purchase Order Report";
                    PO: Record "PO SubForm";
                begin

                    PO.SetRange(ID, "No.");
                    if PO.FindSet() then begin
                        report1.SetTableView(PO);
                        report1.Run();
                    end;

                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        code_unit: Codeunit "PO Codeunit";
    begin
        "Order Type" := code_unit.GetOrderType();
    end;

    trigger OnOpenPage()
    var
        code_unit: Codeunit "PO Codeunit";
    begin
        if "No." <> '' then
            code_unit.SetPurchaseOrderNo("No.");
    end;


    trigger OnAfterGetRecord()
    begin

        if status = status::Released then begin
            page_editable := true;
            reopen_enabled := false;
            listPart_editable := true;
            post_enabled := true;
            getPRLines_enabled := false;
        end
        else
            if status = status::"Pending Approval" then begin
                page_editable := false;
                reopen_enabled := true;
                listPart_editable := false;
                post_enabled := false;
                getPRLines_enabled := false;
            end
            else begin
                page_editable := true;
                reopen_enabled := false;
                post_enabled := false;
                SendForApproval_enabled := true;
                getPRLines_enabled := true;
                if "No." = '' then
                    listPart_editable := false
                else
                    listPart_editable := true;
            end;




    end;

    var
        page_editable: Boolean;
        reopen_enabled: Boolean;
        listPart_editable: Boolean;
        SendForApproval_enabled: Boolean;
        getPRLines_enabled: Boolean;
        post_enabled: Boolean;


}