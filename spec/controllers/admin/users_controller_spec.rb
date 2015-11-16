require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  # Create first admin user
  let!(:admin) { create(:admin) }

  describe 'GET index' do
    context 'when not signed in' do
      before { get :index }
      it_behaves_like :an_unauthorized_request
    end

    context 'when signed in' do
      context 'when normal user' do
        let!(:user) { create(:user) }
        before do
          sign_in user
          get :index
        end

        it_behaves_like :an_unauthorized_request
      end

      context 'when admin' do
        before do
          sign_in admin
          get :index
        end

        it 'assigns @users' do
          expect(assigns(:users)).to be
        end

        it 'renders /admin/users/index' do
          expect(response).to render_template('admin/users/index')
        end
      end
    end
  end

  describe 'GET edit' do
    let(:user) { create(:user) }

    context 'when not signed in' do
      before { get :edit, id: user }

      it_behaves_like :an_unauthorized_request
    end

    context 'when signed in' do
      context 'when normal user' do
        let!(:other_user) { create(:user) }
        before do
          sign_in other_user
          get :edit, id: user
        end

        it_behaves_like :an_unauthorized_request
      end

      context 'when admin' do
        before do
          sign_in admin
          get :edit, id: user
        end

        it 'assigns @user' do
          expect(assigns(:user)).to eq user
        end

        it 'renders admin/users/edit' do
          expect(response).to render_template('admin/users/edit')
        end
      end
    end
  end

  describe 'POST confirm' do
    before { sign_in admin }
    context 'when user not admin_confirmed' do
      let!(:user) { create(:user, admin_confirmed: false) }

      it 'updates admin_confirmed column' do
        expect{
          post :confirm, id: user.id
          user.reload
        }.to change(user, :admin_confirmed).from(false).to(true)
      end

      it 'sends email to user' do
        expect{
          post :confirm, id: user.id
        }.to change(ActionMailer::Base.deliveries, :size).by(1)
      end

      describe 'request' do
        before { post :confirm, id: user.id }

        it 'assigns @user' do
          expect(assigns(:user)).to eq user
        end

        it 'redirect_to @user' do
          expect(response).to redirect_to user
        end
      end
    end

    context 'when user admin_confirmed' do
      let!(:user) { create(:user) }

      it 'updates admin_confirmed column' do
        expect{
          post :confirm, id: user.id
          user.reload
        }.to change(user, :admin_confirmed).from(true).to(false)
      end

      it 'does not send email to user' do
        expect{
          post :confirm, id: user.id
        }.not_to change(ActionMailer::Base.deliveries, :size)
      end

      describe 'request' do
        before { post :confirm, id: user.id }

        it 'assigns @user' do
          expect(assigns(:user)).to eq user
        end

        it 'redirect_to @user' do
          expect(response).to redirect_to user
        end
      end
    end

    context 'when invalid user' do
      let(:user) { build(:user, phone: nil) }
      before { user.save(validate: false) }

      it 'does not update user' do
        expect{
          post :confirm, id: user.id
          user.reload
        }.not_to change{user}
      end

      describe 'request' do
        before { post :confirm, id: user.id }

        it 'assigns @user' do
          expect(assigns(:user)).to eq user
          expect(assigns(:user).valid?).to eq false
        end

        it 'renders :edit' do
          expect(response).to render_template('admin/users/edit')
        end
      end
    end
  end
end
