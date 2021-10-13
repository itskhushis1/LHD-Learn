package com.example.android.background.sync;

import android.support.annotation.NonNull;

import com.evernote.android.job.Job;
import com.evernote.android.job.JobRequest;

import java.util.concurrent.TimeUnit;

public class WaterReminderJob extends Job {

    public static final String TAG = "water_reminder_job";

    @NonNull
    @Override
    protected Result onRunJob(Params params) {
        ReminderTasks.executeTask(getContext(), ReminderTasks.ACTION_CHARGING_REMINDER);
        return Result.SUCCESS;
    }

    public static void scheduleJob() {
        new JobRequest.Builder(WaterReminderJob.TAG)
                .setPeriodic(TimeUnit.MINUTES.toMillis(15))
                .setUpdateCurrent(true)
                .build()
                .schedule();
    }

}
