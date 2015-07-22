class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  has_many :exams, dependent: :destroy

  validates :name, presence: true, length: {maximum: 60}

  before_create :set_default_role

  enum role: [:normal, :admin]

  private
  def set_default_role
    self.role ||= :normal
  end

  def self.import file
    spreadsheet = open_spreadsheet file
    header = spreadsheet.row 1
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user = find_by(email: row["email"]) || new
      user.attributes = row.to_hash.slice *row.to_hash.keys
      user.save!
    end
  end

  def self.open_spreadsheet file
    if File.extname file.original_filename
      Roo::CSV.new file.path
    else
      raise I18n.t("import_fail") + "#{file.original_filename}"
    end
  end

  def self.to_csv options = {}
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |user|
        csv << user.attributes.values_at(*column_names)
      end
    end
  end
end
