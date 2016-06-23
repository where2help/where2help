shared_examples :ngos_index do
  context 'when not signed in' do
    it 'redirects to ngo sign_in' do
      get :index
      expect(response).to redirect_to new_ngo_session_path
    end
  end
end
shared_examples :ngos_show do
  context 'when not signed in' do
    it 'redirects to ngo sign_in' do
      get :show, params: { id: 1 }
      expect(response).to redirect_to new_ngo_session_path
    end
  end
end
