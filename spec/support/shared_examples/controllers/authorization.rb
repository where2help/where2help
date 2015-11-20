RSpec.shared_examples :an_unauthorized_request do

  it 'redirects to sign_in' do
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'renders sign_in page with flash' do
    expect(response).to render_template(session[:new])
    expect(flash[:alert]).to be_present
  end
end
