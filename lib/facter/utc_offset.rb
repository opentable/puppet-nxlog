Facter.add("utc_offset") do
  setcode do
    Time.new.strftime('%z')
  end
end
