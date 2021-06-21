page 50125 "Statistic Card"
{
    Caption = 'Statistics';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Statistics;


    layout
    {
        area(Content)
        {
            group("Purchase Order Statis")
            {
                field("Amount Excl. VAT"; "Amount Excl. VAT") { ApplicationArea = All; Editable = false; }
                field("Inv. Discount Amount"; "Inv. Discount Amount") { ApplicationArea = All; }
                field("Total Incl. VAT"; "Total Incl. VAT") { ApplicationArea = All; Editable = false; }
                field("VAT Amount"; "VAT Amount") { ApplicationArea = All; Editable = false; }
                field("Total Excl. VAT"; "Total Excl. VAT") { ApplicationArea = All; Editable = false; }
                field("Purchase(LYC)"; "Purchase(LYC)") { ApplicationArea = All; Editable = false; }
                field(Quantity; Quantity) { ApplicationArea = All; Editable = false; }
                field(Parcels; Parcels) { ApplicationArea = All; Editable = false; }
                field("Net Weight"; "Net Weight") { ApplicationArea = All; Editable = false; }
                field("Gross Weight"; "Gross Weight") { ApplicationArea = All; Editable = false; }
                field(Volume; Volume) { ApplicationArea = All; Editable = false; }
                field("No of Tax Lines"; "No of Tax Lines") { ApplicationArea = All; Editable = false; }
            }
        }
    }


}