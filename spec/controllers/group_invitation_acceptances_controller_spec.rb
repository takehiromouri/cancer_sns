require 'rails_helper'

RSpec.describe GroupInvitationAcceptancesController, type: :controller do
  describe "POST #create" do
    context "when the current user is not the owner of the invitation" do
      it "redirects to root path" do
        user = create(:user)
        group = create(:group)
        invitation = create(:group_membership, user: create(:user), group: group, status: :invited)

        sign_in user
        post :create, params: {group_invitation_id: invitation.id}

        expect(response).to redirect_to root_path
      end
    end

    context "when the user is the owner of the invitation" do
      it "updates the membership to accepted" do
        user = create(:user)
        group = create(:group)
        invitation = create(:group_membership, user: user, group: group, status: :invited)

        sign_in user
        post :create, params: {group_invitation_id: invitation.id}
        invitation.reload

        expect(invitation.status).to eq("accepted")
      end

      it "redirects to group_path" do
        user = create(:user)
        group = create(:group)
        invitation = create(:group_membership, user: user, group: group, status: :invited)

        sign_in user
        post :create, params: {group_invitation_id: invitation.id}        

        expect(response).to redirect_to group_path(group)
      end
    end
  end
end
