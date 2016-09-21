function get-insta
{
 param (
 [string]$tag
 )
   $test = Invoke-RestMethod -Uri "https://api.instagram.com/v1/tags/$tag/media/recent?client_id=73bb039205f843388d6ddcaeaacc1b5a"
   foreach ($item in $test.data)
   {
      

$file = "c:\temp\" + $item.id +".jpg"

Start-BitsTransfer $item.images.standard_resolution.url -Destination $file


[void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")
$form = new-object Windows.Forms.Form
$form.Text = "Image Viewer"
$form.width = 1280
$form.height = 1024
$pictureBox = new-object Windows.Forms.PictureBox
$pictureBox.Width = 1280
$pictureBox.Height = 1024

$pictureBox.Image = [System.Drawing.Image]::Fromfile($file)
$form.controls.add($pictureBox)
$form.Add_Shown( { $form.Activate() } )
$form.ShowDialog()

   }
  

}

