require_relative 'boot'
require 'rails/all'
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    config.load_defaults 5.1

    # generatorを使う際に生成されるファイル
    # テストフレームワークにrspecを指定することでrails g~を実行した際に自動的にspecファイルも生成してくれる
    config.generators do |g|
      g.test_framework :rspec,
                       helper_specs: false,
                       routing_specs: false,
                       view_specs: false,
                       controller_specs: false
    end
    config.generators.system_tests = nil

    # 認証トークンをremoteフォームに埋め込む
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
