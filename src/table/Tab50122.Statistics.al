table 50122 "Statistics"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PRno; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18; Quantity; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Direct Unit Cost Excl. VAT "; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Line Amount Excl. VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Line Discount %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Quantity to Receive"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Quantity Received"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Expected Receipt Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Total Incl. VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Purchase(LYC)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Parcels"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Net Weight"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Gross Weight"; decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Volume"; decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "No of Tax Lines"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Amount Excl. VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Inv. Discount Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Total Excl. VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; PRno)
        {
            Clustered = true;
        }
    }



}