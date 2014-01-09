require 'spec_helper'
describe 'wget' do

  context 'running on OS X' do
    let(:facts) { {:osfamily => 'Darwin'} }

    it { should_not contain_package('wget') }
  end

  context 'running on CentOS' do
    let(:facts) { {:osfamily => 'RedHat'} }

    it {
      should contain_package('wget').with({
        'ensure' => 'installed',
        'name'   => 'wget',
      })
    }
  end

  context 'running on Suse' do
    let(:facts) { {:osfamily => 'Suse'} }

    it {
      should contain_package('wget').with({
        'ensure' => 'installed',
        'name'   => 'wget',
      })
    }
  end

  context 'running on Solaris 9' do
    let(:facts) do
      { :osfamily => 'Solaris',
        :kenerlrelease => '5.9',
      }
    end

    it {
      should contain_package('wget').with({
        'ensure' => 'installed',
        'name'   => ['SUNWwgetr', 'SUNWwgetu'],
      })
    }
  end

  context 'running on Solaris 10' do
    let(:facts) do
      { :osfamily => 'Solaris',
        :kenerlrelease => '5.10',
      }
    end

    it {
      should contain_package('wget').with({
        'ensure' => 'installed',
        'name'   => ['SUNWwgetr', 'SUNWwgetu'],
      })
    }
  end

  context 'running on Solaris 11' do
    let(:facts) do
      { :osfamily => 'Solaris',
        :kernelrelease => '5.11',
      }
    end

    it {
      should contain_package('wget').with({
        'ensure' => 'installed',
        'name'   => 'SUNWwget',
      })
    }
  end


  context 'no version specified' do
    let(:facts) { { :osfamily => 'RedHat' } }

    it { should contain_package('wget').with_ensure('installed') }
  end

  context 'version is 1.2.3' do
    let(:params) { {:version => '1.2.3'} }
    let(:facts) { { :osfamily => 'RedHat' } }

    it { should contain_package('wget').with_ensure('1.2.3') }
  end

  describe 'wget::fetch' do
    let(:facts) { { :osfamily => 'RedHat' } }

    it { should contain_exec('wget-test') \
      .with_command('wget --no-verbose --output-document=/tmp/dest http://localhost/source') }
  end

  describe 'wget::authfetch' do
    let(:facts) { { :osfamily => 'RedHat' } }

    it { should contain_exec('wget-authtest').with({
      'command'     => 'wget --no-verbose --user=myuser --output-document=/tmp/dest http://localhost/source',
      'environment' => 'WGETRC=/tmp/wgetrc-authtest'
      })
    }

    it { should contain_file('/tmp/wgetrc-authtest').with_content('password=mypassword') }
  end
end
