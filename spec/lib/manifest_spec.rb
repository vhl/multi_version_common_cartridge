require 'spec_helper'
require 'multi_version_common_cartridge'

describe MultiVersionCommonCartridge::Manifest do
  let(:manifest) { described_class.new }
  let(:title) { 'my title' }
  let(:language) { 'my language' }

  describe '#set_title' do
    it 'saves the title for the specified language' do
      manifest.set_title(title, language: language)
      expect(manifest.title(language)).to eq(title)
    end

    context 'when a title already exists for the specified language,' do
      it 'replaces the title' do
        manifest.set_title('old title', language: language)
        manifest.set_title(title, language: language)
        expect(manifest.title(language)).to eq(title)
      end
    end

    context 'when no language is specified' do
      it 'defaults to en-US' do
        manifest.set_title(title)
        expect(manifest.title('en-US')).to eq(title)
      end
    end
  end

  describe 'title' do
    it 'returns the title for the specified language' do
      manifest.set_title(title, language: language)
      expect(manifest.title(language)).to eq(title)
    end

    it 'returns nil when no title exists for the specified language' do
      manifest.set_title(title, language: 'other language')
      expect(manifest.title(language)).to be_nil
    end
  end
end
