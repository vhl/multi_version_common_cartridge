require 'spec_helper'
require 'multi_version_common_cartridge'

describe MultiVersionCommonCartridge::Writers::ItemWriter do
  let(:item) { MultiVersionCommonCartridge::Item.new }
  let(:cartridge) { MultiVersionCommonCartridge::Cartridge.new }
  let(:writers_factory) do
    instance_double(MultiVersionCommonCartridge::Writers::Factory)
  end
  let(:child_items) { Array.new(2) { MultiVersionCommonCartridge::Item.new } }
  let(:child_item_writers) do
    child_items.map do
      instance_double(MultiVersionCommonCartridge::Writers::ItemWriter)
    end
  end
  let(:child_items_organization_elements) do
    child_items.map { CommonCartridge::Elements::Organizations::Item.new }
  end
  let(:item_writer) { described_class.new(item, writers_factory, version) }
  let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }
  let(:identifier) { 'some identifier' }
  let(:title) { 'some title' }

  before do
    child_items.each_with_index do |child, index|
      child_item_writer = child_item_writers[index]
      allow(writers_factory)
        .to receive(:item_writer)
        .with(child)
        .and_return(child_item_writer)
      allow(child_item_writer).to receive(:finalize)
      allow(child_item_writer)
        .to receive(:organization_item_element)
        .and_return(child_items_organization_elements[index])
    end
  end

  describe '#initialize' do
    context 'when a non supported version is specified,' do
      let(:version) { 'some random version' }

      it 'raises an error' do
        expect { item_writer }.to raise_error(
          ArgumentError,
          format(described_class::UNSUPPORTED_VERSION_MSG_TEMPLATE, version: version)
        )
      end
    end

    context 'when a supported version is specified,' do
      it 'does not raise an error' do
        described_class::SUPPORTED_VERSIONS.each do |version|
          expect { described_class.new(item, writers_factory, version) }.not_to raise_error
        end
      end
    end
  end

  describe '#finalize' do
    context 'when no identifier is set,' do
      it 'raises an error' do
        item.title = title
        expect { item_writer.finalize }.to raise_error(
          StandardError,
          described_class::MESSAGES[:no_identifier]
        )
      end
    end

    context 'when no title is set,' do
      it 'raises an error' do
        item.identifier = identifier
        expect { item_writer.finalize }.to raise_error(
          StandardError,
          described_class::MESSAGES[:no_title]
        )
      end
    end

    context 'when a title is set,' do
      it 'does not raise an error' do
        item.identifier = identifier
        item.title = title
        expect { item_writer.finalize }.not_to raise_error
      end
    end

    context 'when the item has child items,' do
      # It's the manifest writer that calls #finalize on all items
      # So we want to be sure that the item does not instantiate a writer
      # for each child and that it does not call finalize on it
      before do
        item.identifier = identifier
        item.title = title
        item.children = child_items
        item_writer.finalize
      end

      it 'does not instantiate a writer for each child items' do
        child_items.each do |child_item|
          expect(writers_factory).not_to have_received(:item_writer).with(child_item)
        end
      end

      it 'does not call #finalize on the child items writer' do
        child_item_writers.each do |child_item_writer|
          expect(child_item_writer).not_to have_received(:finalize)
        end
      end
    end
  end

  context 'when finalizing for version 1.3.0,' do
    let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }
    let(:item_element) { item_writer.organization_item_element }

    before do
      item.identifier = identifier
      item.title = title
      item.children = child_items
      item_writer.finalize
    end

    describe '#organization_item_element' do
      it 'returns an organization item element' do
        expect(item_element).to be_a(CommonCartridge::Elements::Organizations::Item)
      end

      it 'sets the element identifier' do
        expect(item_element.identifier).to eq(identifier)
      end

      context 'when the item has a resource' do
        let(:resource) { MultiVersionCommonCartridge::Resources::Resource.new }
        let(:resource_identifier) { 'resource_identifier' }

        it 'sets the element identifierref with the resource identifier' do
          resource.identifier = resource_identifier
          item.resource = resource
          expect(item_element.identifierref).to eq(resource_identifier)
        end
      end

      context 'when the item has no resouce' do
        it 'does not set the element identifierref' do
          expect(item_element.identifierref).to be_nil
        end
      end

      it 'sets the element title' do
        expect(item_element.title).to eq(title)
      end

      it 'sets element.items' do
        expect(item_element.items).to eq(child_items_organization_elements)
      end
    end
  end
end
