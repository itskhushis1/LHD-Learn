package com.example.android.background.sync;

import com.evernote.android.job.Job;
import com.evernote.android.job.JobCreator;

public class WaterReminderJobCreator implements JobCreator {

    @Override
    public Job create(String jobTag) {
        switch (jobTag) {
            case WaterReminderJob.TAG:
                return new WaterReminderJob();
            default:
                return null;
        }
    }
}
