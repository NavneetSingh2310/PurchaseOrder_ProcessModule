tableextension 50120 "Payment Journal Line extn" extends "Gen. Journal Line"
{
    fields
    {
        field(1000; "IDM Purch Order No."; Code[30])
        {
            DataClassification = ToBeClassified;

        }
    }

}

pageextension 50121 "Payment Journal Page Extn" extends "Payment Journal"
{
    layout
    {
        addafter("External Document No.")
        {
            field("IDM Purch Order No."; "IDM Purch Order No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        addfirst(Approval)
        {
            action("Get information")
            {
                Promoted = true;
                trigger OnAction()
                begin
                    Message('%1 - %2-%3-%4-%5', Rec."Journal Template Name", Rec."Journal Batch Name", rec."Journal Batch Id", Rec.Amount, rec.Description);
                    Message("Journal Batch Id");
                end;
            }

        }
    }
}