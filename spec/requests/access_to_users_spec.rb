describe 'POST #create' do
    #有効なユーザーの検証
    context 'valid request' do
      #ユーザーが追加される
      it 'adds a user' do
        expect do
          post signup_path, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end
      #ユーザーが追加されたときの検証
      context 'adds a user' do
        before { post signup_path, params: { user: attributes_for(:user) } }
        subject { response }
        it { is_expected.to redirect_to root_url } 
        it { is_expected.to have_http_status 302 } #リダイレクト成功
      end
    end
    #無効なリクエスト
    context 'invalid request' do
      #無効なデータを作成
      let(:user_params) do
        attributes_for(:user, name: '',
                              email: 'user@invalid',
                              password: '',
                              password_confirmation: '')
      end
      #ユーザーが追加されない
      it 'does not add a user' do
        expect do
          post signup_path, params: { user: user_params }
        end.to change(User, :count).by(0)
      end
    end
  end