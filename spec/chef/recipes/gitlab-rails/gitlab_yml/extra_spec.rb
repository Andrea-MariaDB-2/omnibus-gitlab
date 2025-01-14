require 'chef_helper'

RSpec.describe 'gitlab::gitlab-rails' do
  include_context 'gitlab-rails'

  describe 'extra settings' do
    context 'with default values' do
      it 'renders gitlab.yml without extra settings' do
        expect(gitlab_yml[:production][:extra]).to be nil
      end
    end

    context 'with user specified values' do
      describe 'matomo settings' do
        context 'with just matomo_url specified' do
          before do
            stub_gitlab_rb(
              gitlab_rails: {
                extra_matomo_url: 'http://foobar.com'
              }
            )
          end

          it 'renders gitlab.yml with default values for other matomo settings' do
            expect(gitlab_yml[:production][:extra][:matomo_url]).to eq('http://foobar.com')
            expect(gitlab_yml[:production][:extra][:matomo_site_id]).to be nil
            expect(gitlab_yml[:production][:extra][:matomo_disable_cookies]).to be nil
          end
        end

        context 'with all settings specified' do
          before do
            stub_gitlab_rb(
              gitlab_rails: {
                extra_matomo_url: 'http://foobar.com',
                extra_matomo_site_id: 'foobar',
                extra_matomo_disable_cookies: true
              }
            )
          end

          it 'renders gitlab.yml with specified matomo settings' do
            expect(gitlab_yml[:production][:extra][:matomo_url]).to eq('http://foobar.com')
            expect(gitlab_yml[:production][:extra][:matomo_site_id]).to eq('foobar')
            expect(gitlab_yml[:production][:extra][:matomo_disable_cookies]).to be true
          end
        end
      end
    end
  end
end
