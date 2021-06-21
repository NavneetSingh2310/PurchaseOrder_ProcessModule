pageextension 50120 "Request to Approve extn" extends "Requests to Approve"
{
    layout
    {
        modify(ToApprove)
        {
            Visible = false;
        }



    }
    actions
    {

        addafter(Record)
        {
            action("Open Record")
            {

            }
        }

        modify(Record)
        {
            trigger OnAfterAction()
            var

                PRrec: Record "Purchase Requisition";
                cardPage: Page "Purchase Requisition Card";
                POrec: Record "Purchase Order";
                POCardPage: Page "Purchase Order Card";
                recref: RecordRef;
                varRecRef: Variant;
            begin
                recref.Get(Rec."Record ID to Approve");
                case recref.Number of
                    Database::"Purchase Requisition":
                        begin

                            PRrec.SetFilter("Document No.", Rec."Document No.");
                            cardPage.SetTableView(PRrec);
                            cardPage.Editable := false;
                            cardPage.Run();
                        end;
                    Database::"Purchase Order":
                        begin
                            POrec.SetFilter("No.", Rec."Document No.");
                            POCardPage.SetTableView(POrec);
                            cardPage.Editable := false;
                            POCardPage.Run();
                        end;

                end;


            end;





        }
    }








}