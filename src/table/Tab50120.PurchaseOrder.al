table 50120 "Purchase Order"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Buy-from Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";
        }
        field(3; Vendor; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Location Code"; Text[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(5; "Order Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Direct Expense","Inventory Asset","Fixed Asset";


        }
        field(6; "Department Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "GA Dept","CS Dept","PR Dept";

        }
        field(7; "Require Advance Payment"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Advance Payment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Reason Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Reason Code";
        }
        field(10; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "DR NO."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "ATP No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "SI No."; Integer)
        {

            DataClassification = ToBeClassified;
        }
        field(14; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Status"; Option)
        {
            OptionMembers = "Open","Pending Approval","Released";
        }
        field(16; "Document Type"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Order Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Department Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(20; "Currency Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(21; "Assigned User Id"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }



}