class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :rememberable,
    :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]
  has_attached_file :avatar, styles: {medium: "300x300>", thumb: "100x100#"}, default_url: "/images/missing.png"
  
  has_many :exams, dependent: :destroy

  validates :name, presence: true, length: {maximum: 60}
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

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

  def self.find_for_facebook_oauth auth, signed_in_resource=nil
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    return user if user
    user = User.create(name:auth.extra.raw_info.name,
                       provider:auth.provider,
                       uid:auth.uid,
                       email:auth.info.email,
                       password:Devise.friendly_token[0,20]
                      )
  end
end
