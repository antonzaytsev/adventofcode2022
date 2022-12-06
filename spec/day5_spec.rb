describe Day5 do
  subject(:day_class) { described_class.new }

  describe '#part1' do
    subject(:part) { day_class.part1 }

    it { is_expected.to eq 'RTGWZTHLD' }
  end

  describe '#part2' do
    subject(:part) { day_class.part2 }

    it { is_expected.to eq 'STHGRZZFR' }
  end
end
