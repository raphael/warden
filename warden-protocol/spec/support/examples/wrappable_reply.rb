# coding: UTF-8

shared_examples "wrappable response" do
  let(:wrapped) { subject.wrap }

  it "should respond to #wrap" do
    wrapped.should be_a(Warden::Protocol::WrappedResponse)

    type_const = described_class.name.split("::").last.gsub(/Response$/, "")
    wrapped.type.should == Warden::Protocol::Type.const_get(type_const)
    wrapped.payload.to_s.should == subject.encode.to_s
  end

  it "should retain class when unwrapped" do
    wrapped.response.should be_a(described_class)
  end

  it "should retain properties when unwrapped" do
    compare_without_encoding(wrapped.response.to_hash, subject.to_hash)
  end

  it "should retain properties when encoded and decoded" do
    freshly_wrapped = Warden::Protocol::WrappedResponse.decode(wrapped.encode.to_s)
    compare_without_encoding(freshly_wrapped.response.to_hash, subject.to_hash)
  end
end
