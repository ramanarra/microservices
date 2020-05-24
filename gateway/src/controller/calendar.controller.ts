import { Controller, Logger, Get, UseGuards, Post, Body } from '@nestjs/common';
import { CalendarService } from 'src/service/calendar.service';
import { AppointmentDto } from 'src/dto/appointment.dto';
import { ApiOkResponse, ApiUnauthorizedResponse, ApiBody, ApiBearerAuth } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { Roles } from 'src/common/decorator/roles.decorator';
import { GetUser } from 'src/common/decorator/get-user.decorator';
import { UserDto } from 'src/dto/user.dto';

@Controller('calendar')
export class CalendarController {

    private logger = new Logger('CalendarController');

    constructor( private readonly calendarService : CalendarService){}

    @Get('appointment')
    @ApiOkResponse({ description: 'Appointment List' })
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @Roles('doctor', 'patient')
    getAppointmentList(@GetUser() userInfo : UserDto) {
      return this.calendarService.appointmentList(userInfo);
    }


    @Post('appointment')
    @ApiOkResponse({ description: 'Create Appointment' })
    @ApiBody({ type: AppointmentDto })
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @Roles('admin')
    createAppointment(@GetUser() userInfo : UserDto, @Body() appointmentDto : AppointmentDto) {
      return this.calendarService.createAppointment(userInfo, appointmentDto);
    }

}
