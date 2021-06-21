report 50121 "Purchase Order Report2"
{
    Caption = 'Purchase Order Report';
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = Word;
    WordLayout = '.\PurchaseOrderReport.docx';
    WordMergeDataItem = "PO SubForm";

    dataset
    {
        dataitem("PO SubForm"; "PO SubForm")
        {
            DataItemLink = ID = field("No.");
            DataItemLinkReference = "Purchase Order";
            column(serialNo; serialNo) { }
            column(Amount_Excl__VAT; "Amount Excl. VAT") { }
            column(Date_Needed; "Date Needed") { }
            column(Deptt__Code; "Deptt. Code") { }
            column(Description; Description) { }
            column(Direct_Unit_Cost_Excl__VAT_; "Direct Unit Cost Excl. VAT ") { }
            column(Expected_Receipt_Date; "Expected Receipt Date") { }
            column(Gross_Weight; "Gross Weight") { }
            column(ID; ID) { }
            column(Inv__Discount_Amount; "Inv. Discount Amount") { }
            column(Line_Amount_Excl__VAT; "Line Amount Excl. VAT") { }
            column(Line_Discount__; "Line Discount %") { }
            column(Line_No_; "Line No.") { }
            //column(Location_Code; "Location Code") { }
            column(Net_Weight; "Net Weight") { }
            column(No_of_Tax_Lines; "No of Tax Lines") { }
            column(ItemNo_; "No.") { }
            column(PR_No_; "PR No.") { }
            column(Purpose; Purpose) { }
            column(Quantity; Quantity) { }
            column(Registered_User_Name; "Registered User Name") { }
            column(Register_User_Id; "Register User Id") { }
            column(Total_Amount; "Total Amount") { }
            column(Unit_of_Measure; "Unit of Measure") { }
            trigger OnAfterGetRecord()

            begin
                serialNo := serialNo + 1;
            end;

        }
        dataitem("Purchase Order"; "Purchase Order")
        {
            column("COMPANY_NAME"; CompanyName) { }
            column(Advance_Payment_Amount; "Advance Payment Amount")
            {

            }
            column(Assigned_User_Id; "Assigned User Id") { }
            column(ATP_No_; "ATP No.") { }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
            column(Currency_Code; "Currency Code") { }
            column(Department_Code; "Department Code") { }
            column(Department_Type; "Department Type") { }
            column(Document_Date; "Document Date") { }
            column(Document_Type; "Document Type") { }
            column(DR_NO_; "DR NO.") { }
            column(Due_Date; "Due Date") { }
            column(Location_Code; "Location Code") { }
            column(No_; "No.") { }
            column(Order_Date; "Order Date") { }
            column(Order_Type; "Order Type") { }
            column(Posting_Date; "Posting Date") { }
            column(Reason_Code; "Reason Code") { }
            column(Require_Advance_Payment; "Require Advance Payment") { }
            column(SI_No_; "SI No.") { }
            column(Status; Status) { }
            column(Vendor; Vendor) { }


            dataitem(VendorData; Vendor)
            {
                DataItemLink = "No." = field("Buy-from Vendor No.");
                DataItemLinkReference = "Purchase Order";
                column(Address; Address) { }
                column(City; City) { }
                column(Country_Region_Code; "Country/Region Code") { }
                column(County; County) { }
                column(Contact; Contact) { }
            }
        }
    }

    trigger OnInitReport()
    begin
        serialNo := 0;
    end;

    var
        serialNo: Integer;
}