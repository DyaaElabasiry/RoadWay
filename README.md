# RoadWay

A mobile app designed to identify which seats in your car are exposed to hot sun rays during your trip, helping you avoid discomfort.
Additionally, the app features an alarm that notifies you a certain number of minutes before reaching your destination.


## Features

- Identify sun exposure on each car seat
- An alarm that fires a certain number of minutes before reaching your destination

## How it works
### Calculating sun location
- having the current and destination location we should convert it to a vector to get the angle
- after that we should convert the Azimuth angle which ranges from `( -180 , 180 )` to the standard postion system which ranges from `( 0 , 360 )` <br>
<img src="https://github.com/user-attachments/assets/be7cf97e-e0a6-4f6a-8f4d-33066aa6e5fb" alt="Illustration"  width="72%" height="72%" >
 <br><br>

- then compare the location angle with the Azimuth angle to find whether the sun is on the left or the right of the car<br>
<img src="https://github.com/user-attachments/assets/e032d3bb-f74f-40bf-a550-8f6f6c8f4217" alt="Illustration"  width="72%" height="72%">



  
### when to fire the alarm
 assuming the car moves at 80 km/hr  which is 1333 meter/min  <br>
 having the time and the distance between my location and the destination location 
`if (distance < 1333 * time) {
        setAlarm();
        }`

## Screenshots
- Maps
<img src="https://github.com/user-attachments/assets/4ff020b7-9a6d-4dd6-b236-9a220872bb32" alt="Maps"  height="500">

<br><br>
- Saving location
<img src="https://github.com/user-attachments/assets/7b43352a-aaf9-4b69-91a4-6bb854903189" alt="Saving location"  height="500">

<br><br>
- Setting alarm
<img src="https://github.com/user-attachments/assets/380e8c17-cca6-4b00-b268-51dc2a9130a9" alt="Setting alarm"  height="500">

<br><br>
- Weather
<img src="https://github.com/user-attachments/assets/48185d6d-2f49-4674-b24a-7fd517b0b3ce" alt="Weather"  height="500">

<br><br>
- Alarm
<img src="https://github.com/user-attachments/assets/ad995e47-86d8-45aa-8a4e-895037358c91" alt="Alarm"  height="500">

<br><br>
- Sharing location to the app
<video height="500" src="https://github.com/user-attachments/assets/7bad127d-abff-4efa-a837-c3e064190bbe" frameborder="0"></video>


## Get the app
you can download the apk from [here](https://github.com/DyaaElabasiry/RoadWay/releases/tag/v1.0.0)

## Problems I faced
- location links shared from the app cannot be converted to the long link to get the coordinates<br>
for example a link like this shared from the web `https://maps.app.goo.gl/T1Y5uQKh5Vz96ciE6`<br>
 when doing a `head` request will give us a link like this <br>
`https://www.google.com/maps/place/Smouha,+Ezbet+Saad,+Sidi+Gaber,+Alexandria+Governorate+5432062/@31.2155409,29.9317063,15z/data=!3m1!4b1!4m14!1m7!3m6!1s0x145f7dde50d07af1:0xf81539722bee9a34!2z2YHZitmE2Kcg2K8uINmF2K3ZhdivINmK2YjYs9mB!8m2!3d30.8722396!4d29.583379!16s%2Fg%2F11rq3jmykt!3m5!1s0x14f5c4919c447a91:0xd0f971e233ebf6c9!8m2!3d31.2155235!4d29.9420061!16s%2Fg%2F121hdy4k?entry=ttu` <br>
we can clearly see that the coordinates are `@31.2155409,29.9317063`<br>
- while doing a `head` request on a link like this `https://maps.app.goo.gl/6krMgNbhm8ASrF9R6` shared form the mobile google maps app doesn't give me the same link that has the coordinates in it so a work around for this is to share the link to RoadWay from the browser
