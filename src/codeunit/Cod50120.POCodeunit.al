codeunit 50120 "PO Codeunit"
{
    SingleInstance = true;
    procedure SetPurchaseOrderNo(no: Code[20])
    begin
        CurrentPONumber := no;
    end;

    procedure GetPurchaseOrderNo(): Code[20]
    begin
        exit(CurrentPONumber);
    end;

    procedure SetOrderType(name: Option)
    begin
        CurrentOrderType := name;
    end;

    procedure GetOrderType(): Option
    begin
        exit(CurrentOrderType);
    end;

    procedure SendPOForApproval(DocNo: Code[20])
    var
        rec: Record "Purchase Order";
        Request: Record "Approval Entry";
        userSetup: Record "User Setup";
        Total_Amount: Decimal;
        POResources: Record "PO SubForm";
    begin
        Message('An approval request has been sent.');
        rec.Get(DocNo);
        rec.status := rec.status::"Pending Approval";
        rec.Modify();
        Request."Record ID to Approve" := Rec.RecordId;


        userSetup.Get(UserId);
        if userSetup."Approver ID" = '' then
            Request."Approver ID" := UserId
        else
            Request."Approver ID" := userSetup."Approver ID";

        Total_Amount := 0;
        POResources.SetRange(ID, DocNo);
        if POResources.FindSet() then
            repeat
                Total_Amount := Total_Amount + POResources."Total Amount";
            until POResources.Next() = 0;
        Request.Amount := Total_Amount;
        Request."Amount (LCY)" := Total_Amount;
        Request."Currency Code" := 'INR';
        Request.Status := Request.Status::Open;
        Request."Document No." := DocNo;
        Request."Sender ID" := UserId;

        Request.Insert();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure ApproveInPRTable(approvalEntry: Record "Approval Entry")
    var
        rec: Record "Purchase Requisition";
        myNotification: Notification;
        userSetup: Record "User Setup";
        Request: Record "Approval Entry";
        ReleasedPRLines: Record "PR Released Resources";
        AllResources: Record "PR Resources";
        recref: RecordRef;
        POrec: Record "Purchase Order";
        rec2: Record "Purchase Requisition";

    begin
        recref.Get(approvalEntry."Record ID to Approve");
        userSetup.get(approvalEntry."Approver ID");
        if userSetup."Approver ID" <> '' then begin

            Request."Record ID to Approve" := approvalEntry."Record ID to Approve";
            Request."Approver ID" := userSetup."Approver ID";
            Request.Status := Request.Status::Open;
            Request."Document No." := approvalEntry."Document No.";
            Request."Sender ID" := userSetup."User ID";

            Request.Insert();
            case recref.Number of
                database::"Purchase Requisition":
                    begin
                        rec2.Get(approvalEntry."Document No.");
                        rec2.Reviewer := userSetup."User ID";
                        rec2.Modify();

                    end;

            end;

            myNotification.Message('Approval Request Reviewed and Send for further Approval');
            myNotification.Send();

        end
        else begin

            case recref.Number of
                Database::"Purchase Requisition":
                    begin

                        rec.Get(approvalEntry."Document No.");
                        rec.status := rec.status::Released;
                        rec.Approver := userSetup."User ID";
                        AllResources.SetRange(ID, rec."Document No.");
                        if AllResources.FindSet() then
                            repeat
                                AllResources.Processed := true;
                                AllResources.Modify();

                            until AllResources.Next() = 0;
                        rec.Modify();
                        myNotification.Message('Approved');
                        myNotification.Send();

                    end;
                Database::"Purchase Order":
                    begin
                        POrec.Get(approvalEntry."Document No.");
                        POrec.Status := POrec.Status::Released;
                        POrec.Modify();
                        myNotification.Message('Approved');
                        myNotification.Send();

                    end;

            end;



        end;


    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure RejectInPRTable(approvalEntry: Record "Approval Entry")
    var
        rec: Record "Purchase Requisition";
        myNotification: Notification;
        recref: RecordRef;
        POrec: Record "Purchase Order";
    begin
        recref.Get(approvalEntry."Record ID to Approve");
        case recref.Number of
            Database::"Purchase Requisition":
                begin
                    rec.Get(approvalEntry."Document No.");
                    rec.status := rec.status::Open;
                    rec.Modify();
                end;
            Database::"Purchase Order":
                begin
                    POrec.Get(approvalEntry."Document No.");
                    POrec.Status := POrec.Status::Released;
                    POrec.Modify();
                end;
        end;

        myNotification.Message('Rejected');
        myNotification.Send();

    end;

    procedure ReOpenPO(DocNo: Code[20])
    var
        Request: Record "Approval Entry";
        rec: Record "Purchase Order";

    begin
        rec.Get(DocNo);
        Request.SetRange("Document No.", DocNo);


        if Request.FindSet() then
            repeat
                if Request.Status = Request.Status::Open then begin
                    Request.DeleteAll();
                    rec.status := rec.status::Open;
                    rec.Modify();
                    Message('Document Re-opened!');
                end;

            until Request.Next() = 0
        else
            Error('No such Appoval request found!');
    end;

    procedure ClearAllTablesData()
    var
        tbl1: Record "PO SubForm";
        tbl2: Record "Purchase Requisition";
        tbl3: Record "Purchase Order";
        tbl4: Record "Approval Entry";
        tbl5: Record "PR Resources";
    begin
        tbl1.DeleteAll();
        tbl2.DeleteAll();
        tbl3.DeleteAll();
        tbl4.DeleteAll();
        tbl5.DeleteAll();

    end;

    procedure GeneratePostedPurchaseReceipt(Rec: Record "Purchase Order")
    var
        PurchaseReceipt: Record "Purch. Rcpt. Header";
        ReceiptLines: Record "Purch. Rcpt. Line";
        POSubFormLines: Record "PO SubForm";
        company: Record "Company Information";
        Vendor: Record Vendor;
        DocNo: Code[25];
        Posting_item_count: Integer;
        Line_no: Integer;
    begin

        //PurchaseReceipt.DeleteAll();
        //ReceiptLines.DeleteAll();
        Posting_item_count := 0;
        Line_no := 0;
        company.get;
        DocNo := format(GetNextPostedPurchaseReceiptNumber());
        Vendor.SetRange("No.", Rec."Buy-from Vendor No.");
        Vendor.FindFirst();
        PurchaseReceipt."No." := format(GetNextPostedPurchaseReceiptNumber());
        PurchaseReceipt."Buy-from Vendor Name" := Vendor.Name;
        PurchaseReceipt."Buy-from Vendor Name 2" := Vendor."Name 2";
        PurchaseReceipt."Buy-from Address" := Vendor.Address;
        PurchaseReceipt."Buy-from Address 2" := Vendor."Address 2";
        PurchaseReceipt."Buy-from City" := Vendor.City;
        PurchaseReceipt."Buy-from Contact No." := Vendor.Contact;
        PurchaseReceipt."Buy-from Country/Region Code" := Vendor."Country/Region Code";
        PurchaseReceipt."Buy-from County" := Vendor.County;
        PurchaseReceipt."Buy-from Post Code" := Vendor."Post Code";
        PurchaseReceipt."Buy-from Vendor No." := Vendor."No.";
        PurchaseReceipt."Applies-to Doc. No." := rec."No.";
        PurchaseReceipt."Applies-to Doc. Type" := PurchaseReceipt."Applies-to Doc. Type"::" ";
        PurchaseReceipt."Currency Code" := Vendor."Currency Code";
        PurchaseReceipt."Document Date" := Today;
        PurchaseReceipt."Due Date" := Rec."Due Date";
        PurchaseReceipt."Pay-to Address" := Vendor.Address;
        PurchaseReceipt."Pay-to Address 2" := Vendor.Address;
        PurchaseReceipt."Pay-to Vendor No." := Vendor."No.";
        PurchaseReceipt."Pay-to City" := Vendor.City;
        PurchaseReceipt."Pay-to Name" := Vendor.Name;
        PurchaseReceipt."Pay-to County" := Vendor.County;
        PurchaseReceipt."Pay-to Country/Region Code" := Vendor."Country/Region Code";
        PurchaseReceipt."Pay-to Contact" := Vendor.Contact;
        PurchaseReceipt."Pay-to Post Code" := Vendor."Post Code";
        PurchaseReceipt."Payment Terms Code" := Vendor."Payment Terms Code";
        PurchaseReceipt."Ship-to Address" := company.Address;
        PurchaseReceipt."Ship-to Address 2" := company."Address 2";
        PurchaseReceipt."Ship-to City" := company.City;
        PurchaseReceipt."Ship-to Code" := company."Country/Region Code";
        PurchaseReceipt."Ship-to Name" := company.Name;


        POSubFormLines.SetRange(ID, Rec."No.");
        if POSubFormLines.FindSet() then begin
            repeat

                if POSubFormLines."Quantity to Receive" > 0 then begin
                    Posting_item_count := Posting_item_count + 1;
                    Line_no := Line_no + 1;
                    ReceiptLines.Init();
                    ReceiptLines."Document No." := DocNo;
                    ReceiptLines."Buy-from Vendor No." := Vendor."No.";
                    ReceiptLines.Type := ReceiptLines.Type::Item;
                    ReceiptLines."No." := POSubFormLines."No.";
                    ReceiptLines.Description := POSubFormLines.Description;
                    ReceiptLines."Direct Unit Cost" := POSubFormLines."Direct Unit Cost Excl. VAT ";
                    ReceiptLines."Job Line Discount %" := POSubFormLines."Line Discount %";
                    ReceiptLines."Unit of Measure" := POSubFormLines."Unit of Measure";
                    ReceiptLines."Planned Receipt Date" := Today;
                    ReceiptLines."Expected Receipt Date" := POSubFormLines."Expected Receipt Date";
                    ReceiptLines."Order Date" := Rec."Document Date";
                    ReceiptLines."Location Code" := rec."Location Code";
                    ReceiptLines.Quantity := POSubFormLines."Quantity to Receive";
                    ReceiptLines."Line No." := Line_no;
                    ReceiptLines."Qty. Rcd. Not Invoiced" := POSubFormLines."Quantity to Receive";
                    ReceiptLines."Job Line Amount" := (POSubFormLines."Quantity to Receive" * POSubFormLines."Direct Unit Cost Excl. VAT ") - ((POSubFormLines."Line Discount %" / 100) * (POSubFormLines."Quantity to Receive" * POSubFormLines."Direct Unit Cost Excl. VAT "));
                    ReceiptLines."Location Code" := POSubFormLines."Location Code";

                    ReceiptLines.Insert();
                end;
                POSubFormLines.Quantity := POSubFormLines.Quantity - POSubFormLines."Quantity to Receive";
                POSubFormLines."Quantity Received" := POSubFormLines."Quantity Received" + POSubFormLines."Quantity to Receive";
                POSubFormLines."Quantity to Receive" := 0;
                POSubFormLines.Modify();

            until POSubFormLines.Next() = 0;
            if Posting_item_count = 0 then
                Message('Nothing to post')
            else begin
                PurchaseReceipt.Insert();
                Message('Posted Purchase Receipt Generated');
            end;


        end;


    end;

    procedure GetNextPostedPurchaseReceiptNumber(): Integer
    var
        PurchaseReceipt: Record "Purch. Rcpt. Header";
        val: Integer;
    begin
        if PurchaseReceipt.IsEmpty then
            exit(107001)
        else begin
            PurchaseReceipt.FindLast();
            Evaluate(val, PurchaseReceipt."No.");
            exit(val + 1);
        end;

    end;

    procedure GeneratePaymentJournalEntry(Rec: Record "Purchase Order")
    var
        PaymentJournal: Record "Gen. Journal Line";
        myNotification: Notification;
        items: Record Vendor;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CurrentSeries: Code[15];
        Series: Record "No. Series";
    begin
        PaymentJournal.Init();
        PaymentJournal."Posting Date" := Today;
        PaymentJournal."Document No." := 'GJNL-PMT';
        CurrentSeries := PaymentJournal."Document No.";
        Series.Get(CurrentSeries);
        PaymentJournal."Document No." := NoSeriesMgt.GetNextNo(PaymentJournal."Document No.", 0D, true);
        PaymentJournal."Document Type" := PaymentJournal."Document Type"::Payment;
        PaymentJournal."IDM Purch Order No." := Rec."No.";
        PaymentJournal."Account Type" := PaymentJournal."Account Type"::Vendor;
        PaymentJournal."Account No." := Rec."Buy-from Vendor No.";
        PaymentJournal.Amount := Rec."Advance Payment Amount";
        PaymentJournal."Payment Method Code" := 'BANK';
        PaymentJournal."Line No." := getNextLineNo();
        PaymentJournal."Journal Batch Name" := 'ADVANCES';
        PaymentJournal."Journal Template Name" := 'PAYMENT';
        PaymentJournal.Description := Rec.Vendor;
        PaymentJournal."Bal. Account Type" := PaymentJournal."Bal. Account Type"::"Bank Account";
        PaymentJournal."Bal. Account No." := 'GIRO';
        PaymentJournal.Insert();
        myNotification.Message('Payment Journal Entry Created');
        myNotification.Send();


    end;

    procedure getNextLineNo(): Integer
    var
        PaymentJournal: Record "Gen. Journal Line";
        lineNo: Integer;

    begin

        PaymentJournal.SetCurrentKey("Line No.");
        PaymentJournal.Find('+');
        lineNo := PaymentJournal."Line No.";
        exit(lineNo + 1);
    end;



    var
        CurrentPONumber: Code[20];
        CurrentOrderType: Option;
        CurrentPurchaseOrderNo: Code[20];
}