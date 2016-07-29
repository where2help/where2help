shared_examples :a_personal_bar do
  it 'has public attribute @people' do
    expect(subject.people).to eq 2
  end
  it 'has public attribute @needed' do
    expect(subject.needed).to eq 10
  end
  it 'has 3 items' do
    expect(subject.items.size).to eq 3
    expect(subject.items).to all(be_an ProgressBar::Item)
  end

  describe 'items' do
    let(:items) { subject.items }

    it 'has first item with percentage for one person' do
      item = items.first
      expect(item.send :size).to eq 'width: 10%'
    end
    it 'has second item with percentage for other users' do
      item = items.second
      expect(item.send :size).to eq 'width: 10%'
    end
    it 'has third item with percentage for missing users' do
      item = items.last
      expect(item.send :size).to eq 'width: 80%'
    end
  end
end

shared_examples :a_public_bar do
  it 'has public attribute @people' do
    expect(subject.people).to eq 2
  end
  it 'has public attribute @needed' do
    expect(subject.needed).to eq 10
  end
  it 'has 2 items' do
    expect(subject.items.size).to eq 2
    expect(subject.items).to all(be_an ProgressBar::Item)
  end

  describe 'items' do
    let(:items) { subject.items }

    it 'has first item with percentage signed up users' do
      item = items.first
      expect(item.send :size).to eq 'width: 20%'
    end
    it 'has second item with percentage for missing users' do
      item = items.last
      expect(item.send :size).to eq 'width: 80%'
    end
  end
end
