import { Controller, Logger, Get, UseGuards, Post, UseFilters, Body, UsePipes, ValidationPipe } from '@nestjs/common';
import { CalendarService } from 'src/service/calendar.service';
import { ApiOkResponse, ApiUnauthorizedResponse, ApiBody, ApiBearerAuth, ApiCreatedResponse, ApiBadRequestResponse } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { Roles } from 'src/common/decorator/roles.decorator';
import { GetUser } from 'src/common/decorator/get-user.decorator';
import { UserDto, AppointmentDto } from 'common-dto';
import { AllExceptionsFilter } from 'src/common/filter/all-exceptions.filter';

@Controller('calendar')
@UsePipes(new ValidationPipe({ transform: true }))
@UseFilters(AllExceptionsFilter)
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
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBadRequestResponse({description:'Invalid Schema'})
    @ApiBody({ type: AppointmentDto })
    @ApiBearerAuth('JWT')
    @UseGuards(AuthGuard())
    @Roles('admin')
    createAppointment(@GetUser() userInfo : UserDto, @Body() appointmentDto : AppointmentDto) {
      this.logger.log(`Appointment  Api -> Request data ${JSON.stringify(appointmentDto)}`);
      return this.calendarService.createAppointment(userInfo, appointmentDto);
    }

}
